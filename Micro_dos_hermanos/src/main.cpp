#include <Arduino.h>
#include <SerialFunctions.h>

#ifndef LED_BUILTIN
#define LED_BUILTIN 2
#endif

// Define the used Flags
// _flag flagMain;
// #define DECODE_COMPLETE flagMain.bit.b0

// VARIABLES
uint8_t data;
int id, flags;
float peso;
uint8_t DECODE_COMPLETE = 0;
uint8_t PRINT_RESULTS = 0;

// Prototipado
void blink(uint8_t times);
void DebugPrint(String Mensaje);
void PrintResults();

// FUCTIONS

void setup()
{
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  SerialSetup();
  blink(3);
}

void loop()
{
  ReadSerRXBuff(&id, &flags, &peso, &DECODE_COMPLETE);

  if (DECODE_COMPLETE && (flags & 0x04) == 0)
  {
    if (PRINT_RESULTS)
    {
      PrintResults();
    }
    DECODE_COMPLETE = 0x00;
  }

  if (Serial.available())
  {
    data = Serial.read();
    Serial.print("DIJISTE: ");
    Serial.println(data, HEX);
    switch (data)
    {
    case 0x30:
      PRINT_RESULTS = 0x00;
      break;
    case 0x31:
      PRINT_RESULTS = 0x01;
      break;
    default:
      PRINT_RESULTS = 0x00;
      break;
    }
  }
}

void PrintResults()
{
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
}

void DebugPrint(String Mensaje)
{
  Serial.print("DBG: ");
  Serial.println(Mensaje);
}

void blink(uint8_t times)
{
  for (uint8_t i = 0; i < times; i++)
  {
    digitalWrite(LED_BUILTIN, 1);
    delay(50);
    digitalWrite(LED_BUILTIN, 0);
    delay(250);
  }
}