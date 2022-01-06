#include <Arduino.h>

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

// Define the used Flags

#define SCOPEISON flag1.bit.b0
#define SENDDATA flag1.bit.b1

_flag flag1;

// Define ASCII representation characters
#define STX 0x02
#define CR 0x0D
#define LF 0x0A
#define ETX 0x03

// Define the states of the input reader

#define WAITINGSTX 0
#define WAITINGID 1
#define WAITINGCR 2
#define WAITINGLF 3
#define WAITINGNT 4
#define WAITINGFG 5
#define WAITINGETX 6

// Variables

//      Variables for serial port
uint8_t checksumSerTX, checksumSerRX, stateReadSer;
uint8_t indexWriteSerTX, indexReadSerTX, indexReadSerRX, indexWriteSerRX;
uint8_t rxBuff[256], txBuff[256], pinsValue, numberOfSteps, parametros[16];
//      Variables for bluetooth port

//      Another variables
unsigned long timeout1, timeout2;

// function prototyping

void AddDataToTXBuff(unsigned long waitingTime);
void PutHeaderIntx();
void PutByteIntx(uint8_t byte);
void SendTXData();
boolean TXBuffHasData();

void ReadSerRXBuff();
boolean SerRXBuffHasData();
void DecodeSerRXBuff();
void DecodeSerMsg(uint8_t id, uint8_t parameter);

// Functions

// Functions for Write the Serial outputs

void AddDataToTXBuff(unsigned long waitingTime)
{
  if ((millis() - timeout2) > waitingTime)
  {
    PutHeaderIntx();
    PutByteIntx(indexVoltageRead * 2 + 3);
    PutByteIntx(0x00);
    PutByteIntx(0x3A);
    PutByteIntx(0xB0);
    PutByteIntx(indexVoltageRead * 2);
    for (uint8_t i = 0; i < indexVoltageRead; i++)
    {
      PutByteIntx(voltageRead[i] & 0xFF);
      PutByteIntx(voltageRead[i] >> 8);
    }
    PutByteIntx(checksumSerTX);
    indexVoltageRead = 0;
    timeout2 = millis();
  }
}

void PutHeaderIntx()
{
  txBuff[indexWriteSerTX++] = STX;
  checksumSerTX = ;
}

void PutByteIntx(uint8_t byte)
{
  txBuff[indexWriteSerTX++] = byte;
  checksumSerTX += byte;
}

void SendTXData()
{
  if (TXBuffHasData())
  {
    if (Serial.availableForWrite())
    {
      Serial.write(txBuff[indexReadSerTX++]);
    }
  }
}

boolean TXBuffHasData()
{
  if (indexReadSerTX != indexWriteSerTX)
  {
    return true;
  }
  else
  {
    return false;
  }
}

// Functions for Read the Serial inputs

void ReadSerRXBuff()
{
  while (Serial.available())
  {
    rxBuff[indexWriteSerRX++] = Serial.read();
  }
  if (SerRXBuffHasData())
  {
    DecodeSerRXBuff();
  }
}

boolean SerRXBuffHasData()
{
  if (indexReadSerRX != indexWriteSerRX)
  {
    return true;
  }
  return false;
}

void DecodeSerRXBuff()
{
  switch (stateReadSer)
  {
  case WAITINGSTX:
    if (rxBuff[indexReadSerRX++] == STX)
    {
      stateReadSer = WAITINGID;
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
    }
    break;
  case WAITINGLF:
    if (rxBuff[indexReadSerRX++] == LF)
    {
      //It depends
    }
    else
    {
      stateReadSer = WAITINGSTX;
    }
    break;
  case WAITINGID:
    stateReadSer = WAITINGCR;
    break;
  case WAITINGCR:
    break;
  }
}

void DecodeSerMsg(uint8_t id, uint8_t parameter)
{
}

// Original functions

void setup()
{
  pinMode(2, OUTPUT);
  Serial.begin(9600,);
  stateReadSer = WAITINGSTX;
}

void loop()
{
  ReadSerRXBuff();
  
  SendTXData();
}