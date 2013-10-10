#include <Wire.h>

const int encRintPin=2;
const int encRApin=6;
const int encRBpin=7;

const int encLintPin=3;
const int encLApin=4;
const int encLBpin=5;

const char EncoderLU[16]={0,1,-1,0,-1,0,0,1,1,0,0,-1,0,-1,1,0};

volatile int Rstate=0;
volatile int Lstate=0;
volatile int cnt[2]={0,0};
volatile int err[2]={0,0};

void setup() {
  Wire.begin(2); // address
  Wire.onRequest(requestEvent);
  Wire.onReceive(receiveEvent); // register event
  // put your setup code here, to run once:
  pinMode(encRApin,INPUT_PULLUP);
  pinMode(encRBpin,INPUT_PULLUP);
  pinMode(encRintPin,INPUT);
  //attachInterrupt(0,Rhandle,CHANGE);

  pinMode(encLApin,INPUT_PULLUP);
  pinMode(encLBpin,INPUT_PULLUP);
  pinMode(encLintPin,INPUT);
  //attachInterrupt(1,Lhandle,CHANGE);
  //delay(1);
  Rhandle();
  Lhandle();
  err[0]=0;err[1]=0;
  cnt[0]=0;cnt[1]=0;
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly: 
  Rhandle();
  Lhandle();
  Serial.print(cnt[0]);
  Serial.print("\t");
  Serial.print(err[0]);
  Serial.print("\t");
  Serial.print(cnt[1]);
  Serial.print("\t");
  Serial.println(err[1]);
}

void Rhandle() {
  int NewState;
  NewState=digitalRead(encRApin);
  NewState<<=1;
  NewState+=digitalRead(encRBpin);
  if ((Rstate^NewState)==3) err[1]++; // only one pin can change at a time
  Rstate=(Rstate<<2)+NewState; // a number between 0 and 15
  cnt[1]+=EncoderLU[Rstate];
  Rstate=NewState;
}

void Lhandle() {
  int NewState;
  NewState=digitalRead(encLApin);
  NewState<<=1;
  NewState+=digitalRead(encLBpin);
  if ((Lstate^NewState)==3) err[0]++; // only one pin can change at a time
  Lstate=(Lstate<<2)+NewState; // a number between 0 and 15
  cnt[0]+=EncoderLU[Lstate];
  Lstate=NewState;
}

void requestEvent() {
  Wire.write((uint8_t*)cnt,4);
} // requestEvent

void receiveEvent(int howMany) {
  while(Wire.available())
    switch (Wire.read()) {
      case 1: cnt[1]=0;break;
      case 2: cnt[0]=0;break;
      default: // should not happen
      Serial.println("Invalid I2C command");
    }
} //receiveEvent
