/* object-oriented version of Claw */
//#include "Arduino.h"
#include <Wire.h>
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

float actualAngle=0;

// digital pin assignment
// pin 0 and 1 used for serial communication
int led = 13;

// analog pin assignment

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

unsigned long tRef, tNow;

void setup() {
  // UART communication
  //Serial.begin(9600);
  Serial.begin(115200);

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
    angle=atoi(inputString);
    //mpu.setZGyroOffset(atoi(inputString));
  }

  actualAngle=MPUhandler();
  if (doWrite) {
     Serial.print("\tactAng ");
     Serial.println(actualAngle);
  }

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
    //if (WaitCtr>0) {Serial.print("Wait ");Serial.println(WaitCtr);}
    
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
        angle-=2.0*float(gyro)/0.9389e7;
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
