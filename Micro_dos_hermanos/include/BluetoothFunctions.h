#include <Arduino.h>
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

// Define the states of the input reader
#define WAITINGSTX 0x00
#define WAITINGCR 0x01
#define WAITINGLF 0x02
#define WAITINGETX 0x03
#define WAITINGDATA 0x04
#define WAITINGCOM 0x05
#define WAITINGPAT 0x06
#define WAITINGTIME 0x07

// Define ASCII representation characters
#define STX 0x02
#define CR 0x0D
#define LF 0x0A
#define ETX 0x03
#define TARA 0x54
#define NETO 0x4E
#define LISTA 0x4C

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
} _flagBt;

_flagBt flagBt;

#define DATA_COMPLETE_BT flagBt.bit.b0

// Prototipado
void ReadBtRXBuff(char *patente, char *momento, uint8_t *comando);
uint8_t BtRXBuffHasData();
void DecodeBtRXBuff(char *patente, char *momento, uint8_t *comando);
void SaveReadedData(char *patente, char *momento);
void BtSetup();

void BtDebugPrint(String Mensaje);

void SendPeso(float pesoValido);

void SendList(const uint8_t *patentesasas, char *momentosT, float *taras, char *momentossN, float *netos, uint8_t indexList, const uint8_t bufferSize);

// Instanciado de clase bluetooth serial
BluetoothSerial SerialBT;

// VARIABLES

//      Variables for serial port
uint8_t stateReadBt, stateDecodeBt;
uint8_t indexReadBtRX, indexWriteBtRX;
uint8_t rxBuffBt[256];
uint8_t comandoLoc;

// Functions for Read the Serial inputs

void BtSetup()
{
    SerialBT.begin("Controlador Sipel"); //Bluetooth device name
    stateReadBt = WAITINGSTX;
    indexWriteBtRX = 0;
    indexReadBtRX = 0;
}

void ReadBtRXBuff(char *patente, char *momento, uint8_t *comando)
{
    if (SerialBT.available())
    {
        rxBuffBt[indexWriteBtRX] = SerialBT.read();
        // BtDebugPrint("d_in: " + String(rxBuffBt[indexWriteBtRX], HEX));
        indexWriteBtRX++;
    }
    if (BtRXBuffHasData() != 0)
    {
        // DebugPrint("Decoding");
        DecodeBtRXBuff(patente, momento, comando);
    }
}

uint8_t BtRXBuffHasData()
{
    uint8_t diferencia = indexWriteBtRX - indexReadBtRX;
    // DebugPrint("SBHD: " + String(indexWriteBtRX) + " vs " + String(indexReadBtRX));
    if (diferencia != 0)
    {
        return diferencia;
    }
    return 0;
}

void DecodeBtRXBuff(char *patente, char *momento, uint8_t *comando)
{
    switch (stateReadBt)
    {
    case WAITINGSTX:
        if (rxBuffBt[indexReadBtRX++] == STX)
        {
            DATA_COMPLETE_BT = false;
            stateReadBt = WAITINGCOM;
        }
        break;
    case WAITINGCR:
        if (rxBuffBt[indexReadBtRX++] == CR)
        {
            stateReadBt = WAITINGLF;
        }
        else
        {
            stateReadBt = WAITINGSTX;
            // BtDebugPrint("Error 01");
        }
        break;
    case WAITINGLF:
        if (rxBuffBt[indexReadBtRX++] == LF)
        {
            if (DATA_COMPLETE_BT)
            {
                stateReadBt = WAITINGETX;
            }
            else
            {
                stateReadBt = WAITINGDATA;
            }
        }
        else
        {
            // BtDebugPrint("Error 02");
            stateReadBt = WAITINGSTX;
        }
        break;
    case WAITINGCOM:
        comandoLoc = rxBuffBt[indexReadBtRX++];
        if (comandoLoc == TARA || comandoLoc == NETO)
        {
            stateReadBt = WAITINGDATA;
            stateDecodeBt = WAITINGPAT;
        }
        else if (comandoLoc == LISTA)
        {
            stateReadBt = WAITINGETX;
        }
        else
        {
            stateReadBt = WAITINGSTX;
        }
        break;
    case WAITINGDATA:
        if (BtRXBuffHasData() > 15)
        {
            // BtDebugPrint("Llego data");
            SaveReadedData(patente, momento);
            stateReadBt = WAITINGCR;
        }
        break;
    case WAITINGETX:
        if (rxBuffBt[indexReadBtRX++] == ETX)
        {
            *comando = comandoLoc;
            stateReadBt = WAITINGSTX;
            // BtDebugPrint("Llego todo");
        }
        else
        {
            stateReadBt = WAITINGSTX;
            // BtDebugPrint("Error 03");
        }
        break;
    default:
        stateReadBt = WAITINGSTX;
        // BtDebugPrint("Error 04");
        break;
    }
}

void SaveReadedData(char *patente, char *momento)
{
    switch (stateDecodeBt)
    {
    case WAITINGPAT:
        // BtDebugPrint("PATENTE");
        for (uint8_t i = 0; i < 9; i++)
        {
            // BtDebugPrint(String(rxBuffBt[indexReadBtRX]));
            *(patente + i) = (char)rxBuffBt[indexReadBtRX++];
        }
        stateDecodeBt = WAITINGTIME;
        break;
    case WAITINGTIME:
        // BtDebugPrint("MOMENTO");
        for (uint8_t i = 0; i < 16; i++)
        {
            // BtDebugPrint(String(rxBuffBt[indexReadBtRX]));
            *(momento + i) = (char)rxBuffBt[indexReadBtRX++];
        }
        DATA_COMPLETE_BT = true;
        break;
    default:
        stateReadBt = WAITINGSTX;
        break;
    }
}

void SendPeso(float pesoValido)
{
    // BtDebugPrint("ENVIANDO PESO");
    // BtDebugPrint(String(pesoValido));
    // SerialBT.write(0x02);
    SerialBT.println(String(pesoValido, 3));
    // SerialBT.write(0x03);
}

void BtDebugPrint(String Mensaje)
{
    Serial.print("DBG(BT): ");
    Serial.println(Mensaje);
}

void SendList(const uint8_t *patentesasas, const uint8_t  *momentosT,  float *taras, const uint8_t  *momentossN, float *netos, uint8_t indexList, const uint8_t bufferSize)
{
    uint8_t actIndex = 0;
    for (uint8_t i = bufferSize; i > 0; i--)
    {
        actIndex = (indexList + i) % bufferSize;
        SerialBT.write(patentesasas + (9 * actIndex), 9);
        SerialBT.print("\t");
        SerialBT.write(momentosT + (16 * actIndex), 16);
        SerialBT.print("\t");
    }
}