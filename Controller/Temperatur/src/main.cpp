#include <Arduino.h>
#include <mainHeader.h>
#include <wire.h>

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  int output;
  double temp;
  output=analogRead(0);      //Read the analog port 0 and store the value in val
  temp=getTemp(output);
  Serial.println(temp);
  delay(1000); 
}