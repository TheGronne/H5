#include <wire.h>
#include <Arduino.h>

// device ID and address

#define DEV_TYPE 0x90 >> 1 // shift required by wire.h
#define DEV_ADDR 0x00 // DS1621 address is 0
#define SLAVE_ID DEV_TYPE | DEV_ADDR

// DS1621 Registers & Commands

#define RD_TEMP 0xAA // read temperature register
#define ACCESS_TH 0xA1 // access high temperature register
#define ACCESS_TL 0xA2 // access low temperature register
#define ACCESS_CFG 0xAC // access configuration register
#define RD_CNTR 0xA8 // read counter register
#define RD_SLOPE 0xA9 // read slope register
#define START_CNV 0xEE // start temperature conversion
#define STOP_CNV 0X22 // stop temperature conversion

// DS1621 configuration bits

#define DONE B10000000 // conversion is done
#define THF B01000000 // high temp flag
#define TLF B00100000 // low temp flag
#define NVB B00010000 // non-volatile memory is busy
#define POL B00000010 // output polarity (1 = high, 0 = low)
#define ONE_SHOT B00000001 // 1 = one conversion; 0 = continuous conversion

void setConfig(byte cfg)
{
Wire.beginTransmission(SLAVE_ID);
Wire.write(ACCESS_CFG);
Wire.write(cfg);
Wire.endTransmission();
delay(15); // allow EE write time to finish
}

byte getReg(byte reg)
{
Wire.beginTransmission(SLAVE_ID);
Wire.write(reg); // set register to read
Wire.endTransmission();
Wire.requestFrom(SLAVE_ID, 1);
byte regVal = Wire.read();
return regVal;
}

void setThresh(byte reg, int tC)
{
if (reg == ACCESS_TL || reg == ACCESS_TH) {
Wire.beginTransmission(SLAVE_ID);
Wire.write(reg); // select temperature reg
Wire.write(byte(tC)); // set threshold
Wire.write(0); // clear fractional bit
Wire.endTransmission();
delay(15);
}
}


void startConversion(boolean start)
{
Wire.beginTransmission(SLAVE_ID);
if (start == true)
Wire.write(START_CNV);
else
Wire.write(STOP_CNV);
Wire.endTransmission();
}

int getTemp(byte reg)
{
int tC;

if (reg == RD_TEMP || reg == ACCESS_TL || reg == ACCESS_TH) {
byte tVal = getReg(reg);
if (tVal >= B10000000) { // negative?
tC = 0xFF00 | tVal; // extend sign bits
}
else {
tC = tVal;
}
return tC; // return threshold
}
return 0; // bad reg, return 0
}

int getHrTemp()
{
startConversion(true); // initiate conversion
byte cfg = 0;
while (cfg < DONE) { // let it finish
cfg = getReg(ACCESS_CFG);
}

int tHR = getTemp(RD_TEMP); // get whole degrees reading
byte cRem = getReg(RD_CNTR); // get counts remaining
byte slope = getReg(RD_SLOPE); // get counts per degree

if (tHR >= 0)
tHR = (tHR * 100 - 25) + ((slope - cRem) * 100 / slope);
else {
tHR = -tHR;
tHR = (25 - tHR * 100) + ((slope - cRem) * 100 / slope);
}
return tHR;
}