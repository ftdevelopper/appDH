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
uint8_t actIndex = 0;

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
void blink(uint8_t times_per_second);
// void DebugPrint(String Mensaje);
// void PrintResults();
void RespuestaBluetooth();

// FUCTIONS

void setup()
{
  // Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  SerialSetup();
  BtSetup();
}

void loop()
{

  if (IsBluetoothConected())
  {
    digitalWrite(LED_BUILTIN, HIGH);
  }
  else
  {
    blink(2);
  }

  ReadBtRXBuff(&patenteNueva[0], &momentoNuevo[0], &comando);

  if (comando != 0x00 && IsBluetoothConected())
  {
    RespuestaBluetooth();
  }

  ReadSerRXBuff(&id, &flags, &peso, &DECODE_SER_COMPLETE);

  if (DECODE_SER_COMPLETE && (flags & 0x05) == 0 && PRINT_RESULTS == 0x01)
  {
    pesoValido = peso;
    SendFloat(pesoValido);
    DECODE_SER_COMPLETE = 0x00;
    PRINT_RESULTS = 0x00;
    // SendString((String)comando);
    switch (comando)
    {
    case 'T':
      indexList = (indexList + 1) % BUFFER_SIZE;
      for (uint8_t i = 0; i < 9; i++)
      {
        patentes[indexList][i] = patenteNueva[i];
      }
      for (uint8_t i = 0; i < 16; i++)
      {
        momentosT[indexList][i] = momentoNuevo[i];
      }
      taras[indexList] = pesoValido;
      break;
    case 'N':
      for (uint8_t i = BUFFER_SIZE; i > 0; i--)
      {
        if (String(patentes[(indexList + i) % BUFFER_SIZE]) == String(patenteNueva))
        {
          netos[(indexList + i) % BUFFER_SIZE] = pesoValido;
          for (uint8_t j = 0; j < 16; j++)
          {
            momentosN[(indexList + i) % BUFFER_SIZE][j] = momentoNuevo[j];
          }
          break;
        }
      }
      break;
      break;
    }
    comando = 0x00;
  }
}

void RespuestaBluetooth()
{
  switch (comando)
  {
  case 'T':
    PRINT_RESULTS = 0x01;
    break;
  case 'N':
    PRINT_RESULTS = 0x01;
    break;
  case 'L':
    for (uint8_t i = BUFFER_SIZE; i > 0; i--)
    {
      actIndex = (indexList + i) % BUFFER_SIZE;
      if (taras[actIndex] != 0)
      {
      SendString((String)actIndex);
      SendString((String)patentes[actIndex]);
      SendString((String)momentosT[actIndex]);
      SendFloat(taras[actIndex]);
      SendString((String)momentosN[actIndex]);
      SendFloat(netos[actIndex]);
      }
    }
    comando = 0x00;
    break;
  }
}

void blink(uint8_t times_per_second)
{
  digitalWrite(LED_BUILTIN, !((millis() * times_per_second / 1000) % 2));
}