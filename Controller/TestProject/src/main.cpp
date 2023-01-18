#include <mainHeader.h>
#include <Arduino.h>

void setup() {
  Serial.println("Hello world");
}

void loop() {
  int i = 0;
  Serial.println(Sum(i + 1, i + 2));
  i++;
  delay(1000);
}