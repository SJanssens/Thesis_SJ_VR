/* object-oriented version of Claw */
//#include "Arduino.h"
#include <Servo.h>
#include <Wire.h>
#include "EchoSounder.h"
#include "Claw.h"
#include "TwoWD.h"
//#include "Wire.h"
#include "I2Cdev.h"
//#include "MPU6050_6Axis_MotionApps20.h"

//debug
//#include <MemoryFree.h>
//boolean blink=false;
unsigned char iString=0;
char inputString[20];         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete
unsigned long tWrite=0;
boolean doWrite=false;

// digital pin assignment
// pin 0 and 1 used for serial communication
const int triggerPin=11;
const int echoPin=3; // external interrupt 1
const int dirR=4;
const int pwmR=5;
const int pwmL=6;
const int dirL=7;
const int leftClawPin=9;
const int rightClawPin=8;
const int liftPin=10;
int led = 13;

// analog pin assignment
int batteryPin=0;
int clawSensePin=1;
int liftSensePin=2;

float batteryVoltage;

TwoWD drive(dirR,pwmR,dirL,pwmL);
Claw claw(leftClawPin,rightClawPin,liftPin,clawSensePin,liftSensePin);
EchoSounder SR04(triggerPin,echoPin);

union angleT {
  float f; // read from slave arduino
  char c[4];
};
union angleT angle;

unsigned char TransmitIndex=0;
int Rwheel=0;
int Lwheel=0;
//I2Cdev wheels;

int Cycle=0; // number of lifting cycles completed
int grip; // force with which object is squeezed
int weight; // weight of object lifted (0 ... 1023)
unsigned long tRef, tNow;

unsigned int distance =0;

void setup() {
  angle.f=0.0;
  // UART communication
  //Serial.begin(9600);
  Serial.begin(115200);

  // I2C communication with wheel encoder and gyro
  Wire.begin(2); // address as a slave
  Wire.onRequest(requestEvent);
  Wire.onReceive(receiveEvent); // register event

  // pointer
  pinMode(led, OUTPUT);

  // echo sounder. Ugly, I agree
  attachInterrupt(1,echoReceived,FALLING);

  // claw
  claw.init();
  
  // drive train
  drive.enable();

  // battery condition
  pinMode(batteryPin, INPUT);

  tWrite=millis();
  
  Serial.println("init done.");
} // setup

void loop() {
    if (millis()-tWrite>876) {
      doWrite=true;
      tWrite=millis();
    }
    else doWrite=false;

  if (stringComplete) {
    Serial.println(atoi(inputString)); 
    // clear the string:
    iString = 0;
    stringComplete = false;
    angle.f=atof(inputString);
  }


  if (doWrite) {
     Serial.print(Rwheel);
     Serial.print("\t");
     Serial.print(Lwheel);
     Serial.print(" RL | ");
     Serial.print(angle.f);
     Serial.print(" deg | ");
  }
   
  // manage battery
  batteryVoltage=(5.0/1023)*analogRead(batteryPin)+0.4;
  if (doWrite) {
    Serial.print(batteryVoltage);
    Serial.print(" V | ");
  }
  if (batteryVoltage<3.6) drive.disable();
  if (batteryVoltage>3.7) drive.enable();

  distance=SR04.distance(); // in cm
  if (doWrite) {
    Serial.print(distance);
    Serial.print(" cm | ");
  }
  
  tNow=millis();
  if (distance>120) {
    drive.setRefAngle();
    digitalWrite(led, HIGH);
  }
  else
    digitalWrite(led, LOW);
   // approach object
  if (distance>25) { // still in far approach
    drive.straightContinuous((long)distance*150L);
    claw.open();
    claw.lift(0);
  }
  else {
    // pulse to approach object closely
    if (claw.isOpen()) drive.straightPulsed(5000L); 
  } 

  //
  if (claw.isOpen()) {
    // claw opened: close claw if close robot enough
    if (distance>7) tRef=tNow; // reset waiting
    else {
      drive.straightContinuous(0);
      if (tNow-tRef>200)
        if (Cycle==0) 
          claw.squeeze(600); // long enough close enough to start closing the claw
        else {
          Cycle=0;
          tRef=tNow;
        }
    }
  }
  else { // claw not opened
    drive.setRefAngle();
    if (!claw.squeezeComplete()) tRef=tNow; // not squeezing hard enough yet
   // Serial.print(tNow-tRef);
   // Serial.print(" tNow-tRef | ");
    if ((Cycle==0)&&(claw.liftComplete())&&(!claw.isLifted())&&(tNow-tRef>1000)) { // squeezed stably long enough => lift
      weight=claw.lift(100);
      tRef=tNow;
    }
    if (claw.isLifted()&&(tNow-tRef>2000)) { // lifted long enough: put down
      claw.lift(0);
      tRef=tNow;
      Cycle++;
    }
    if ((Cycle>0)&&claw.liftComplete()&&(!claw.isLifted())) { // finished grabbing, lifting and putting down
        claw.open();
        tRef=millis();
    }
//    Serial.print(weight);
//    Serial.print(" weight | ");
    //Serial.print(tNow-tRef);
    //Serial.print(" tNow-tRef | ");
  }
  
  drive.actualAngle=angle.f;
  if (doWrite) {
     //Serial.print("\tactAng ");
     //Serial.println(drive.actualAngle);
     Serial.println("");
  }
  SR04.handler();
  claw.handler();
  drive.handler();
//  Serial.print(" mem ");
//  Serial.print(freeMemory());

  //Serial.println();
} // loop

//void serialEvent() {
//  while (Serial.available()) {
//    // get the new byte:
//    char inChar = (char)Serial.read(); 
//  }
//}


void echoReceived() {
  SR04._idx++;
  if (SR04._idx==SOUNDER_BUFF_LEN) SR04._idx=0;
  SR04._buff[SR04._idx]=micros()-SR04._tLast;
  SR04._uptodate=false;
}

void requestEvent() {
  Wire.write(99);
  TransmitIndex=0;
} // requestEvent

void receiveEvent(int howMany) {
  char c;
  while(Wire.available()) {
    c=Wire.read();
//    Serial.print(TransmitIndex);
//    Serial.print(" TX | ");
    switch (TransmitIndex) {
      case 0:
      case 1:
      case 2:
      case 3: angle.c[TransmitIndex]=c;break;
      case 4: Lwheel+=c;break;
      case 5: Rwheel+=c;break;
      case 6: TransmitIndex=-(c==99); break;
    }
    TransmitIndex+=1;
  }
} //receiveEvent

void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    Serial.readBytes(&inputString[iString],1);
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inputString[iString] == '\n') {
      stringComplete = true;
      iString++;
      inputString[iString]=0;
    } 
    iString++;
  }
}
