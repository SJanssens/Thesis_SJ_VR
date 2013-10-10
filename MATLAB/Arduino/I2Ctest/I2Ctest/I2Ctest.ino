#include <Wire.h>

byte TransmitIndex=0;
int Lwheel=0;
int Rwheel=0;

void setup() {
  Serial.begin(115200);

  // I2C communication with wheel encoder and gyro
  Wire.begin(2); // address as a slave
  Wire.onReceive(receiveEvent); // register event
  Serial.println("init done.");
}

void receiveEvent(int howMany) {
  char c;
  while(Wire.available()) {
    c=Wire.read();
    TransmitIndex+=1;
    Serial.print(TransmitIndex);
    Serial.print(" TX | ");
    switch (TransmitIndex) {
      case 1: Lwheel+=c;break;
      case 2: Rwheel+=c;break;
      case 3: TransmitIndex=0;break;
    }
  }
} //receiveEvent

void loop() {
  Serial.print(Lwheel);
  Serial.print(" L | ");
  Serial.print(Rwheel);
  Serial.print(" R | ");
  Serial.print(TransmitIndex);
  Serial.print(" TI");
  Serial.println(" ");
 delay(100);
}
