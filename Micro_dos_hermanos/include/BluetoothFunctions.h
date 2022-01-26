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
#define WAITINGCOM 0x04
#define WAITINGDATA 0x05
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
} _flag;

_flag flagBt;

#define DATA_COMPLETE flagBt.bit.b0

// Prototipado
void ReadBtRXBuff(char *patente, char *momento, uint8_t *comando);
uint8_t BtRXBuffHasData();
void DecodeBtRXBuff(char *patente, char *momento, uint8_t *comando);
void SaveReadedData(char *patente, char *momento);
void BtSetup();

// Instanciado de clase bluetooth serial
BluetoothSerial SerialBT;

// VARIABLES

//      Variables for serial port
uint8_t stateReadBt, stateDecodeBt;
uint8_t indexReadBtRX, indexWriteBtRX;
uint8_t rxBuff[256], txBuff[256];
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
    if (Serial2.available())
    {
        rxBuff[indexWriteBtRX] = SerialBT.read();
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
        if (rxBuff[indexReadBtRX++] == STX)
        {
            DATA_COMPLETE = false;
            stateReadBt = WAITINGCOM;
        }
        break;
    case WAITINGCR:
        if (rxBuff[indexReadBtRX++] == CR)
        {
            stateReadBt = WAITINGLF;
        }
        else
        {
            stateReadBt = WAITINGSTX;
            // DebugPrint("Error 01");
        }
        break;
    case WAITINGLF:
        if (rxBuff[indexReadBtRX++] == LF)
        {
            if (DATA_COMPLETE)
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
            // DebugPrint("Error 02");
            stateReadBt = WAITINGSTX;
        }
        break;
    case WAITINGCOM:
        comandoLoc = rxBuff[indexReadBtRX++];
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
            // DebugPrint("Llego data");
            SaveReadedData(patente, momento);
            stateReadBt = WAITINGCR;
        }
        break;
    case WAITINGETX:
        if (rxBuff[indexReadBtRX++] == ETX)
        {
            *comando = comandoLoc;
            stateReadBt = WAITINGSTX;
        }
        else
        {
            stateReadBt = WAITINGSTX;
            // DebugPrint("Error 03");
        }
        break;
    default:
        stateReadBt = WAITINGSTX;
        // DebugPrint("Error 04");
        break;
    }
}

void SaveReadedData(char *patente, char *momento)
{
    switch (stateDecodeBt)
    {
    case WAITINGPAT:
        for (uint8_t i = 0; i < 9; i++)
        {
            *(patente + i) = (char)rxBuff[indexReadBtRX++];
        }
        stateDecodeBt = WAITINGTIME;
        break;
    case WAITINGTIME:
        for (uint8_t i = 0; i < 16; i++)
        {
            *(momento + i) = (char)rxBuff[indexReadBtRX++];
        }
        DATA_COMPLETE = true;
        break;
    default:
        stateReadBt = WAITINGSTX;
        break;
    }
}