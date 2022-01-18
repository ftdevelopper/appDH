#include <Arduino.h>
#define ANALOG_PIN 4
#define LED_BUILTIN 2
#define LECTURES 255

uint8_t lecture_delay = 1, print_flag = 0;

uint16_t samples_print = 0;

uint16_t lectures_ary[LECTURES];
uint32_t t_init, micros_ary[LECTURES];
void setup()
{
  pinMode(ANALOG_PIN, INPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(115200);
  t_init = micros();
  print_flag = 0;
}

void loop()
{
  // if ((millis() - t_init) > lecture_delay)
  // {
    lectures_ary[0] = analogRead(ANALOG_PIN);
    if (lectures_ary[0] < 1500)
    {
      micros_ary[0] = micros();
      samples_print = LECTURES - 1;
      print_flag = 1;
      while (samples_print)
      {
        lectures_ary[LECTURES - samples_print] = analogRead(ANALOG_PIN);
        micros_ary[LECTURES - samples_print] = micros();
        samples_print--;
      }
      if (print_flag)
      {
        for (uint8_t i = 0; i < LECTURES; i++)
        {
          Serial.println(String(micros_ary[i] - micros_ary[0]) + "\t" + String(lectures_ary[i]));
        }
        print_flag = 0;
      }
    }
    t_init = millis();
  // }
}