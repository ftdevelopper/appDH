#include <Arduino.h>

#define RXD2 16
#define TXD2 17

#define LED_BI 2

// Define ASCII representation characters
#define STX 0x02
#define CR 0x0D
#define LF 0x0A
#define ETX 0x03
#define SPACE 0x20

// Define the states of the input reader
#define WAITINGSTX 0x00
#define WAITINGCR 0x01
#define WAITINGLF 0x02
#define WAITINGETX 0x03
#define WAITINGDATA 0x04
#define WAITINGID 0x05
#define WAITINGNT 0x06
#define WAITINGFG 0x07

//Define chars protocol
#define ID 0x00
#define PN 0x01
#define FG 0x02

//RS485 control
#define SERIAL_COMMUNICATION_CONTROL_PIN 4 // Transmission set pin
#define RS485_TX_PIN_VALUE HIGH
#define RS485_RX_PIN_VALUE LOW

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

// Define the used Flags

#define DATA_COMPLETE flag1.bit.b0

_flag flag1;

// VARIAS DE PRUEBA
char dato_recibido;

// Prototipado
void Read_data();
void blink(uint8_t times);

void ReadSerRXBuff();
uint8_t SerRXBuffHasData();
void DecodeSerRXBuff();
void SaveReadedData();
void DebugPrint(String Mensaje);

int id, flags;
float peso;
char flagsBuf[10];
String id_str = "          ";
String peso_str = "          ";

//      Variables for serial port
uint8_t stateReadSer, stateDecodeSer;
uint8_t indexReadSerRX, indexWriteSerRX;
uint8_t rxBuff[256], txBuff[256];

// Functions for Read the Serial inputs
void ReadSerRXBuff()
{
  if (Serial2.available())
  {
    rxBuff[indexWriteSerRX] = Serial2.read();
    indexWriteSerRX++;
  }
  if (SerRXBuffHasData() != 0)
  {
    // DebugPrint("Decoding");
    DecodeSerRXBuff();
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

void DecodeSerRXBuff()
{
  switch (stateReadSer)
  {
  case WAITINGSTX:
    if (rxBuff[indexReadSerRX++] == STX)
    {
      // DebugPrint("DSRB: " + String(indexWriteSerRX) + " vs " + String(indexReadSerRX));
      // DebugPrint("Data recived");
      DATA_COMPLETE = false;
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
      SaveReadedData();
      stateReadSer = WAITINGCR;
    }
    break;
  case WAITINGETX:
    Serial.printf("id: %u", id);
    Serial.printf("\tPeso: %f", peso);
    Serial.printf("\tFlags: %d", (flags & 0x01) != 0);
    Serial.printf("\t%d", (flags & 0x02) != 0);
    Serial.printf("\t%d", (flags & 0x04) != 0);
    Serial.printf("\t%d", (flags & 0x08) != 0);
    Serial.printf("\t%d", (flags & 0x10) != 0);
    Serial.printf("\t%d", (flags & 0x20) != 0);
    Serial.printf("\t%d", (flags & 0x40) != 0);
    Serial.printf("\t%d\n", (flags & 0x80) != 0);
    stateReadSer = WAITINGSTX;
    //indexReadSerRX++;
    break;
  default:
    stateReadSer = WAITINGSTX;
    // DebugPrint("Error 03");
    break;
  }
}

void SaveReadedData()
{
  switch (stateDecodeSer)
  {
  case WAITINGID:
    id_str = (char)rxBuff[indexReadSerRX++];
    for (uint8_t i = 0; i < 9; i++)
    {
      id_str += (char)rxBuff[indexReadSerRX++];
    }
    id = id_str.toInt();
    stateDecodeSer = WAITINGNT;
    // DebugPrint("SRD: LLego ID = " + String(id));
    break;
  case WAITINGNT:
    peso_str = (char)rxBuff[indexReadSerRX++];
    for (uint8_t i = 0; i < 9; i++)
    {
      peso_str += (char)rxBuff[indexReadSerRX++];
    }
    peso = peso_str.toFloat();
    stateDecodeSer = WAITINGFG;
    // DebugPrint("SRD: LLego NETO = " + String(peso));
    break;
  case WAITINGFG:
    indexReadSerRX += 9;
    flags = rxBuff[indexReadSerRX++];
    DATA_COMPLETE = true;
    // DebugPrint("SRD: LLego FLAGS = " + String(flags));
    break;
  default:
    stateReadSer = WAITINGSTX;
    stateDecodeSer = WAITINGID;
    break;
  }
}

void blink(uint8_t times)
{
  for (uint8_t i = 0; i < times; i++)
  {
    digitalWrite(LED_BI, 1);
    delay(50);
    digitalWrite(LED_BI, 0);
    delay(250);
  }
}
void setup()
{
  Serial.begin(9600);
  pinMode(SERIAL_COMMUNICATION_CONTROL_PIN, OUTPUT);
  digitalWrite(SERIAL_COMMUNICATION_CONTROL_PIN, RS485_RX_PIN_VALUE);
  Serial2.begin(9600, SERIAL_8N1, RXD2, TXD2);

  pinMode(LED_BI, OUTPUT);
  stateReadSer = WAITINGSTX;
  indexWriteSerRX = 0;
  indexReadSerRX = 0;
  blink(5);

  // PRUEBA DE IMPRESION
  // uint8_t prueba01[10] = {0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x01};
  // String prueba01_str;
  // uint8_t pri = 0;
  // int prueba_def;
  // prueba01_str = String(prueba01[pri++], HEX);
  // // DebugPrint(prueba01_str);
  // for (uint8_t i = 0; i < 9; i++)
  // {
  //   prueba01_str += String(prueba01[pri++], HEX);
  // }
  // pri += 9;
  // prueba_def = prueba01[pri++];
  // // DebugPrint(String(prueba_def));

  // Serial.printf("\tFlags: %d", (prueba_def & 0x01) != 0);
  // Serial.printf("\t%d", (prueba_def & 0x02) != 0);
  // Serial.printf("\t%d", (prueba_def & 0x04) != 0);
  // Serial.printf("\t%d", (prueba_def & 0x08) != 0);
  // Serial.printf("\t%d", (prueba_def & 0x10) != 0);
  // Serial.printf("\t%d", (prueba_def & 0x20) != 0);
  // Serial.printf("\t%d", (prueba_def & 0x40) != 0);
  // Serial.printf("\t%d\n", (prueba_def & 0x80) != 0);
}

void loop()
{
  ReadSerRXBuff();
  if (Serial.available())
  {
    Serial.print("DIJISTE: ");
    Serial.println(Serial.read());
  }
}

void DebugPrint(String Mensaje)
{
  Serial.print("DBG: ");
  Serial.println(Mensaje);
}
