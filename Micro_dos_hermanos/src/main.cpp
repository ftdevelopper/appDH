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

//Define chars protocol
#define ID 0x00
#define PN 0x01
#define FG 0x02

//RS485 control
#define SERIAL_COMMUNICATION_CONTROL_PIN 4 // Transmission set pin
#define RS485_TX_PIN_VALUE HIGH
#define RS485_RX_PIN_VALUE LOW

// VARIAS DE PRUEBA
char dato_recibido;

// Prototipado
void Read_data();
void blink(uint8_t times);

// Variables
char dato = ID;

void Read_data(void)
{
  int id, flags;
  float peso;
  char flagsBuf[10];
  String peso_string = "          ";

  id = Serial2.parseInt();
  if (Serial2.read() != CR || Serial2.read() != LF)
  {
    Serial.println("ADM: \tFalla 01");
    return;
  }
  peso_string = Serial2.readStringUntil(CR);
  peso = peso_string.toFloat();

  if (Serial2.read() != LF)
  {
    Serial.println("ADM: \tFalla 02");
    return;
  }
  flags = Serial2.read(flagsBuf, 10);
  if (Serial2.read() == CR && Serial2.read() == LF && Serial2.read() == ETX)
  {
    Serial.printf("\nid: %u", id);
    Serial.printf("\nPeso: %f", peso);
    Serial.printf("\nDisplay negativo: %d", flags & 0x01);
    Serial.printf("\nCero: %d", flags & 0x02);
    Serial.printf("\nMov: %d", flags & 0x04);
    Serial.printf("\nModo: %d", flags & 0x08);
    Serial.printf("\nBruto-: %d", flags & 0x10);
    Serial.printf("\nNO USADO: %d", flags & 0x20);
    Serial.printf("\nDip ilum: %d", flags & 0x40);
    Serial.printf("\nError: %d", flags & 0x80);
    Serial.printf("\nflags: ");
    Serial.println(flags, HEX);
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
  Serial2.begin(4800, SERIAL_8N1, RXD2, TXD2);

  pinMode(LED_BI, OUTPUT);
  blink(5);
}

void loop()
{
  if (Serial2.available())
  {
    Serial.println("ADM: \tLlega");
    if (Serial2.read() == STX)
    {
      delay(500);
      Serial.println("ADM: \tEntro");
      Read_data();
    }
  }
  if (Serial.available())
  {
    Serial.print("DIJISTE: ");
    Serial.println(Serial.read());
  }
}