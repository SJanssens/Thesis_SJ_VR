/* sketch for the slave arduino with functionality:
- wheel encoder: by simple polling
- gyro: based on Jeff Rowberg's code
Interfaces with the main arduino over TWI. This is the master device for
the gyro and for the main arduino (which has address 2).
Sends increments for left wheel position (2 byte int), right wheel position (2 byte int) and angle (4 byte float). 

*/

#include <Wire.h>
#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"

/* wheel encoder */
//const int encRintPin=2;
const int encRApin=6;
const int encRBpin=7;

//const int encLintPin=3;
const int encLApin=4;
const int encLBpin=5;

// lookup table for wheel state transition
const char EncoderLU[16]={0,1,-1,0,-1,0,0,1,1,0,0,-1,0,-1,1,0};

volatile int Rstate=0;
volatile int Lstate=0;
volatile int cnt[2]={0,0};
volatile int err[2]={0,0};

/* gyro */
unsigned long tWrite=0;
boolean doWrite=false;

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

union angleT {
  float f; // read from slave arduino
  char c[4];
};
union angleT angle;

void setup() {
  angle.f=0.0;
  char MainResponse; // response from main arduino board
  // put your setup code here, to run once:
  pinMode(encRApin,INPUT_PULLUP);
  pinMode(encRBpin,INPUT_PULLUP);
//  pinMode(encRintPin,INPUT);
  //attachInterrupt(0,Rhandle,CHANGE);

  pinMode(encLApin,INPUT_PULLUP);
  pinMode(encLBpin,INPUT_PULLUP);
//  pinMode(encLintPin,INPUT);
  //attachInterrupt(1,Lhandle,CHANGE);
  //delay(1);
  Rhandle();
  Lhandle();
  err[0]=0;err[1]=0;
  cnt[0]=0;cnt[1]=0;

  Serial.begin(115200);
  Wire.begin();

  // check if main arduino is connected
  Wire.requestFrom(2, 1);    // request 1 byte from slave device #2
  // timeout
  tWrite=millis();
  MainResponse=0;
  while ((MainResponse==0) && (millis()-tWrite<500))
    while(Wire.available()) {  // slave may send less than requested
      MainResponse = Wire.read();    // receive a byte as character
    }
  if (MainResponse != 99)
    Serial.println("No main arduino found.");
    
  MPUsetup();
  
  tWrite=millis();
}


int Rhandle() {
  int NewState;
  char inc;
  NewState=digitalRead(encRApin);
  NewState<<=1;
  NewState+=digitalRead(encRBpin);
  if ((Rstate^NewState)==3) err[1]++; // only one pin can change at a time
  Rstate=(Rstate<<2)+NewState; // a number between 0 and 15
  //cnt[1]+=EncoderLU[Rstate];
  inc=EncoderLU[Rstate];
  Rstate=NewState;
  return(inc);
}

int Lhandle() {
  int NewState;
  char inc;
  NewState=digitalRead(encLApin);
  NewState<<=1;
  NewState+=digitalRead(encLBpin);
  if ((Lstate^NewState)==3) err[0]++; // only one pin can change at a time
  Lstate=(Lstate<<2)+NewState; // a number between 0 and 15
  //cnt[0]+=EncoderLU[Lstate];
  inc=EncoderLU[Lstate];
  Lstate=NewState;
  return(inc);
}

volatile bool mpuInterrupt = false; // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
    mpuInterrupt = true;
}

void MPUsetup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
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


void loop() {
  char inc;
  
  if (millis()-tWrite>876) {
    doWrite=true;
    tWrite=millis();
  }
  else doWrite=false;

  // wait for MPU interrupt or extra packet(s) available
  while (!mpuInterrupt && (fifoCount < packetSize)) {
    // poll and send wheel position
    Wire.beginTransmission(2);
    Wire.write(angle.c[0]);
    Wire.write(angle.c[1]);
    Wire.write(angle.c[2]);
    Wire.write(angle.c[3]);
    inc=Lhandle();cnt[0]+=inc;
    Wire.write(inc);
    inc=Rhandle();cnt[1]+=inc;
    Wire.write(inc);  
    Wire.write(99);  
    Wire.endTransmission();     // stop transmitting
    
    if (doWrite) {
      Serial.print(cnt[0]);
      Serial.print("\t");
      Serial.print(err[0]);
      Serial.print("\t");
      Serial.print(cnt[1]);
      Serial.print("\t");
      Serial.print(err[1]);
      Serial.print("\t");
      Serial.println(angle.f);
      doWrite=false;
    }
  }
  
  if (!dmpReady) return;

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
      angle.f+=float(gyro)/0.47e7;
      if (angle.f>180.0) angle.f-=360.0;
      if (angle.f<=-180.0) angle.f+=360.0;

  }    

} // loop

