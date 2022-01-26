#include <Arduino.h>

#define RXD2 16
#define TXD2 17

//RS485 control
#define SERIAL_COMMUNICATION_CONTROL_PIN 4 // Transmission set pin
#define RS485_TX_PIN_VALUE HIGH
#define RS485_RX_PIN_VALUE LOW

// Define the states of the input reader
#define WAITINGSTX 0x00
#define WAITINGCR 0x01
#define WAITINGLF 0x02
#define WAITINGETX 0x03
#define WAITINGDATA 0x04
#define WAITINGID 0x05
#define WAITINGNT 0x06
#define WAITINGFG 0x07

// Define ASCII representation characters
#define STX 0x02
#define CR 0x0D
#define LF 0x0A
#define ETX 0x03

// Define the used Flags
// Flags
typedef union
{
  struct
  {
    uint8_t b0 : 1;
    uint8_t b1 : 1;
    uint8_t b2 : 1;
    uint8_t b3 : 1;
    uint8_t b4 : 1;
    uint8_t b5 : 1;
    uint8_t b6 : 1;
    uint8_t b7 : 1;
  } bit;
  uint8_t byte;
} _flag;

_flag flagSer;

#define DATA_COMPLETE flagSer.bit.b0

// Prototipado
void ReadSerRXBuff(int *id, uint8_t *flags, float *peso, uint8_t *decodeComplete);
uint8_t SerRXBuffHasData();
void DecodeSerRXBuff(int *id, uint8_t *flags, float *peso, uint8_t *decodeComplete);
void SaveReadedData(int *id, uint8_t *flags, float *peso);
void SerialSetup();

// VARIABLES
String id_str = "          ";
String peso_str = "          ";

//      Variables for serial port
uint8_t stateReadSer, stateDecodeSer;
uint8_t indexReadSerRX, indexWriteSerRX;
uint8_t rxBuff[256], txBuff[256];

// Functions for Read the Serial inputs

void SerialSetup(){
  pinMode(SERIAL_COMMUNICATION_CONTROL_PIN, OUTPUT);
  digitalWrite(SERIAL_COMMUNICATION_CONTROL_PIN, RS485_RX_PIN_VALUE);
  Serial2.begin(9600, SERIAL_8N1, RXD2, TXD2);
  stateReadSer = WAITINGSTX;
  indexWriteSerRX = 0;
  indexReadSerRX = 0;
}

void ReadSerRXBuff(int *id, uint8_t *flags, float *peso, uint8_t *decodeComplete)
{
    if (Serial2.available())
    {
        rxBuff[indexWriteSerRX] = Serial2.read();
        indexWriteSerRX++;
    }
    if (SerRXBuffHasData() != 0)
    {
        // DebugPrint("Decoding");
        DecodeSerRXBuff(id, flags, peso, decodeComplete);
    }
}

uint8_t SerRXBuffHasData()
{
    uint8_t diferencia = indexWriteSerRX - indexReadSerRX;
    // DebugPrint("SBHD: " + String(indexWriteSerRX) + " vs " + String(indexReadSerRX));
    if (diferencia != 0)
    {
        return diferencia;
    }
    return 0;
}

void DecodeSerRXBuff(int *id, uint8_t *flags, float *peso, uint8_t *decodeComplete)
{
    switch (stateReadSer)
    {
    case WAITINGSTX:
        if (rxBuff[indexReadSerRX++] == STX)
        {
            // DebugPrint("DSRB: " + String(indexWriteSerRX) + " vs " + String(indexReadSerRX));
            // DebugPrint("Data recived");
            DATA_COMPLETE = false;
            *decodeComplete = 0x00;
            stateReadSer = WAITINGDATA;
            stateDecodeSer = WAITINGID;
        }
        break;
    case WAITINGCR:
        if (rxBuff[indexReadSerRX++] == CR)
        {
            stateReadSer = WAITINGLF;
        }
        else
        {
            stateReadSer = WAITINGSTX;
            // DebugPrint("Error 01");
        }
        break;
    case WAITINGLF:
        if (rxBuff[indexReadSerRX++] == LF)
        {
            if (DATA_COMPLETE)
            {
                stateReadSer = WAITINGETX;
            }
            else
            {
                stateReadSer = WAITINGDATA;
            }
        }
        else
        {
            // DebugPrint("Error 02");
            stateReadSer = WAITINGSTX;
        }
        break;
    case WAITINGDATA:
        if (SerRXBuffHasData() > 9)
        {
            // DebugPrint("Llego data");
            SaveReadedData(id, flags, peso);
            stateReadSer = WAITINGCR;
        }
        break;
    case WAITINGETX:
        if (rxBuff[indexReadSerRX++] == ETX)
        {
            *decodeComplete = 0x01;
            stateReadSer = WAITINGSTX;
        }
        else
        {
            stateReadSer = WAITINGSTX;
            // DebugPrint("Error 01");
        }
        break;
    default:
        stateReadSer = WAITINGSTX;
        // DebugPrint("Error 03");
        break;
    }
}

void SaveReadedData(int *id, uint8_t *flags, float *peso)
{
    switch (stateDecodeSer)
    {
    case WAITINGID:
        id_str = (char)rxBuff[indexReadSerRX++];
        for (uint8_t i = 0; i < 9; i++)
        {
            id_str += (char)rxBuff[indexReadSerRX++];
        }
        *id = id_str.toInt();
        stateDecodeSer = WAITINGNT;
        // DebugPrint("SRD: LLego ID = " + String(id));
        break;
    case WAITINGNT:
        peso_str = (char)rxBuff[indexReadSerRX++];
        for (uint8_t i = 0; i < 9; i++)
        {
            peso_str += (char)rxBuff[indexReadSerRX++];
        }
        *peso = peso_str.toFloat();
        stateDecodeSer = WAITINGFG;
        // DebugPrint("SRD: LLego NETO = " + String(peso));
        break;
    case WAITINGFG:
        indexReadSerRX += 9;
        *flags = rxBuff[indexReadSerRX++];
        DATA_COMPLETE = true;
        // DebugPrint("SRD: LLego FLAGS = " + String(flags));
        break;
    default:
        stateReadSer = WAITINGSTX;
        stateDecodeSer = WAITINGID;
        break;
    }
}