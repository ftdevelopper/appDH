#include <Arduino.h>
#include <SerialFunctions.h>
#include <BluetoothFunctions.h>

#ifndef LED_BUILTIN
#define LED_BUILTIN 2
#endif

#define BUFFER_SIZE 30 // de 1 a 255

// VARIABLES
uint8_t data;
int id;
uint8_t flags;
float peso, pesoValido = 0;
uint8_t DECODE_SER_COMPLETE = 0;
uint8_t PRINT_RESULTS = 0;

char patentes[BUFFER_SIZE][9];
char momentosT[BUFFER_SIZE][16];
char momentosN[BUFFER_SIZE][16];
char patenteNueva[9];
char momentoNuevo[16];
float taras[BUFFER_SIZE];
float netos[BUFFER_SIZE];
uint8_t comando = 0x00;
uint8_t indexList = 0x00;

// Prototipado
void blink(uint8_t times);
void DebugPrint(String Mensaje);
void PrintResults();
void RespuestaBluetooth();

// FUCTIONS

void setup()
{
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  SerialSetup();
  BtSetup();
  blink(3);
}

void loop()
{
  ReadSerRXBuff(&id, &flags, &peso, &DECODE_SER_COMPLETE);

  if (DECODE_SER_COMPLETE && (flags & 0x05) == 0)
  {
    pesoValido = peso;
    if (PRINT_RESULTS)
    {
      PrintResults();
    }
    DECODE_SER_COMPLETE = 0x00;
  }

  ReadBtRXBuff(&patenteNueva[0], &momentoNuevo[0], &comando);

  if (comando != 0x00)
  {
    RespuestaBluetooth();
    comando = 0x00;
  }

  if (DECODE_SER_COMPLETE && (flags & 0x05) == 0)
  {
    pesoValido = peso;
    if (PRINT_RESULTS)
    {
      PrintResults();
    }
    DECODE_SER_COMPLETE = 0x00;
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

void RespuestaBluetooth()
{
  switch (comando)
  {
  case 'T':
    indexList = (indexList + 1) % BUFFER_SIZE;
    SendPeso(pesoValido);
    taras[indexList] = pesoValido;
    for (uint8_t i = 0; i < 9; i++)
    {
      patentes[indexList][i] = patenteNueva[i];
    }
    for (uint8_t i = 0; i < 16; i++)
    {
      momentosT[indexList][i] = momentoNuevo[i];
    }
    DebugPrint("Pidieron Tara: " + String(taras[indexList]) + "\t" +
               patentes[indexList] + "\t" + momentosT[indexList]);
    break;
  case 'N':
    SendPeso(pesoValido);
    for (uint8_t i = BUFFER_SIZE; i > 0; i--)
    {
      if (patentes[(indexList + i) % BUFFER_SIZE] == patentes[indexList])
      {
        netos[(indexList + i) % BUFFER_SIZE] = pesoValido;
        break;
      }
    }
    for (uint8_t i = 0; i < 9; i++)
    {
      patentes[indexList][i] = patenteNueva[i];
    }
    for (uint8_t i = 0; i < 16; i++)
    {
      momentosN[indexList][i] = momentoNuevo[i];
    }
    DebugPrint("Pidieron Neto: " + String(netos[indexList]) +
               "\tTara: " + String(taras[indexList]) + "\t" +
               patentes[indexList] + "\t" +
               momentosT[indexList] + "\t" + momentosN[indexList]);
    break;
  case 'L':
    DebugPrint("Pidieron la lista");
    // SendList();
    break;
  default:
    break;
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