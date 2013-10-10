#include <Wire.h>

int Rwheel=0;
int Lwheel=0;

boolean doWrite=false;
unsigned long tWrite=0;

void setup() {
    Wire.begin(); // I hope this doesn't interfere with the gyro
    Serial.begin(115200);
}

void loop() {
    if (millis()-tWrite>200) {
      doWrite=true;
      tWrite=millis();
    }
    else doWrite=false;

    int ToRead=4;
  Wire.requestFrom(2, ToRead); // Lcnt & Rcnt from device 2
  while(Wire.available()&&(ToRead)) { // slave may send less than requested
    if (doWrite) {Serial.print(Wire.available());Serial.print(" ");}
    int c = Wire.read(); // receive as int
    if (doWrite) {Serial.print(c);Serial.print(" ");}
    switch (ToRead) {
      case 4: Lwheel=c;break;
      case 3: Lwheel+=c<<8;break;
      case 2: Rwheel=c;break;
      case 1: Rwheel+=c<<8;break;
    }
    ToRead--;
  }
  if (ToRead) Serial.println("not all bytes received from encoder !");
  if (doWrite) {
     Serial.print(Rwheel);
     Serial.print("\t");
     Serial.print(Lwheel);
     Serial.print(" RL | ");
   }
   if (doWrite) Serial.println();
} // loop
