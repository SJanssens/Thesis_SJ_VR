/* object-oriented version of Claw */
//#include "Arduino.h"
#include <Servo.h>
#include <Wire.h>
#include "EchoSounder.h"
#include "Claw.h"
#include "TwoWD.h"
#include "Wire.h"
#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"

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
MPU6050 mpu;
// MPU control/status vars
bool dmpReady = false; // set true if DMP init was successful
uint8_t mpuIntStatus; // holds actual interrupt status byte from MPU
uint8_t devStatus; // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize; // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount; // count of all bytes currently in FIFO
//uint8_t fifoBuffer[64]; // FIFO storage buffer
uint8_t fifoBuffer[64];
long gyro;
float angle=0;

int Rwheel=0;
int Lwheel=0;
//I2Cdev wheels;

int Cycle=0; // number of lifting cycles completed
int grip; // force with which object is squeezed
int weight; // weight of object lifted (0 ... 1023)
unsigned long tRef, tNow;

unsigned int distance =0;

void setup() {
  // UART communication
  //Serial.begin(9600);
  Serial.begin(115200);

  // I2C wheel encoder
  //Wire.begin(); // I hope this doesn't interfere with the gyro
  
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

  MPUsetup();
  tWrite=millis();
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
    mpu.setZGyroOffsetUser(atoi(inputString));
  }

  // read current wheel positions
  int ToRead=4;
  Wire.requestFrom(2, ToRead); // Lcnt & Rcnt from device 2
  while(Wire.available()&&(ToRead)) { // slave may send less than requested
    int c = Wire.read(); // receive as int
    //Serial.print(c);
    switch (ToRead) {
      case 4: Lwheel=c;break;
      case 3: Lwheel+=c<<8;break;
      case 2: Rwheel=c;break;
      case 1: Rwheel+=c<<8;break;
    }
    ToRead--;
  }
  if (ToRead) Serial.println("not all bytes received from encoder !");
  if (0) {  //(doWrite) {
     Serial.print(Rwheel);
     Serial.print("\t");
     Serial.print(Lwheel);
     Serial.print(" RL | ");
  }
   
  // manage battery
  batteryVoltage=(5.0/1023)*analogRead(batteryPin)+0.4;
  if (0) {//(doWrite) {
    Serial.print(batteryVoltage);
    Serial.print(" V | ");
  }
  if (batteryVoltage<3.6) drive.disable();
  if (batteryVoltage>3.7) drive.enable();

  distance=SR04.distance(); // in cm
  if (0) { //(doWrite) {
    Serial.print(distance);
    Serial.print(" cm | ");
  }
  
  tNow=millis();
  if (distance>50) {
    drive.setRefAngle();
    digitalWrite(led, HIGH);
//    Wire.beginTransmission(2); 
//    Wire.write(1);             // reset R 
//    Wire.write(2);             // reset L 
//    Wire.endTransmission();  
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
  
  drive.actualAngle=0; //MPUhandler();
  if (doWrite) {
     Serial.print("\t");
     Serial.println(drive.actualAngle);
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

volatile bool mpuInterrupt = false; // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
    mpuInterrupt = true;
}

void echoReceived() {
  SR04._idx++;
  if (SR04._idx==SOUNDER_BUFF_LEN) SR04._idx=0;
  SR04._buff[SR04._idx]=micros()-SR04._tLast;
  SR04._uptodate=false;
}

void MPUsetup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
    Wire.begin();
    while (!Serial); // wait for Leonardo enumeration, others continue immediately

    // initialize device
    Serial.println(F("Initializing I2C devices..."));
    mpu.initialize();

    // verify connection
    Serial.println(F("Testing device connections..."));
    Serial.println(mpu.testConnection() ? F("MPU6050 connection successful") : F("MPU6050 connection failed"));

    // load and configure the DMP
    Serial.println(F("Initializing DMP..."));
    devStatus = mpu.dmpInitialize();
    
    // make sure it worked (returns 0 if so)
    if (devStatus == 0) {
        // turn on the DMP, now that it's ready
        Serial.println(F("Enabling DMP..."));
        mpu.setDMPEnabled(true);

        // enable Arduino interrupt detection
        Serial.println(F("Enabling interrupt detection (Arduino external interrupt 0)..."));
        attachInterrupt(0, dmpDataReady, RISING);
        mpuIntStatus = mpu.getIntStatus();

        // set our DMP Ready flag so the main loop() function knows it's okay to use it
        Serial.println(F("DMP ready! Waiting for first interrupt..."));
        dmpReady = true;

        // get expected DMP packet size for later comparison
        packetSize = mpu.dmpGetFIFOPacketSize();
    } else {
        // ERROR!
        // 1 = initial memory load failed
        // 2 = DMP configuration updates failed
        // (if it's going to break, usually the code will be 1)
        Serial.print(F("DMP Initialization failed (code "));
        Serial.print(devStatus);
        Serial.println(F(")"));
    }
} // MPUsetup

float MPUhandler() {
    // if programming failed, don't try to do anything
    if (!dmpReady) return(angle);

    // wait for MPU interrupt or extra packet(s) available
    unsigned WaitCtr=0;
    while (!mpuInterrupt && (fifoCount < packetSize)) WaitCtr++; //return(angle);
    if (WaitCtr>0) {Serial.print("Wait ");Serial.print(WaitCtr);}
    
    // reset interrupt flag and get INT_STATUS byte
    mpuInterrupt = false;
    mpuIntStatus = mpu.getIntStatus();

    // get current FIFO count
    fifoCount = mpu.getFIFOCount();

    // check for overflow (this should never happen unless our code is too inefficient)
    if ((mpuIntStatus & 0x10) || fifoCount == 1024) {
        // reset so we can continue cleanly
        mpu.resetFIFO();
        Serial.println(F("FIFO overflow!"));

    // otherwise, check for DMP data ready interrupt (this should happen frequently)
    } else if (mpuIntStatus & 0x02) {
        // wait for correct available data length, should be a VERY short wait
        while (fifoCount < packetSize) fifoCount = mpu.getFIFOCount();

        // read a packet from FIFO
        mpu.getFIFOBytes((uint8_t*)(&fifoBuffer[0]), packetSize);
       //  Serial.print(fifoCount);
        
        // track FIFO count here in case there is > 1 packet available
        // (this lets us immediately read more without waiting for an interrupt)
        fifoCount -= packetSize;
        gyro=fifoBuffer[24];
        gyro<<=8;gyro|=fifoBuffer[25];
        gyro<<=8;gyro|=fifoBuffer[26];
        gyro<<=8;gyro|=fifoBuffer[27];
        // integrate
        angle-=float(gyro)/0.9389e7;
        if (angle>180.0) angle-=360.0;
        if (angle<=-180.0) angle+=360.0;

        return(angle);
    }    
}

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
