#include <Servo.h>

// digital pin assignment
// pin 0 and 1 used for serial communication
int echoPin= 2;
int triggerPin= 3;
int dirR=4;
int pwmR=5;
int pwmL=6;
int dirL=7;
int leftClawPin=9;
int rightClawPin=8;
int liftPin=10;
int led = 13;

// analog pin assignment
int batteryPin=0;
int clawSensePin=1;
int liftSensePin=2;

signed char velo=256;

float batteryVoltage;

Servo  leftClaw, rightClaw, clawLift;
int clawPos=1;
int liftPos=0;
boolean closeClaw=false;
boolean lifted=false;
int grip; // force with which object is squeezed
int weight; // weight of object lifted (0 ... 1023)
unsigned long tRef, tNow;

unsigned distance =0;

void setup() {
  // echo sounding
  pinMode(echoPin, INPUT);
  pinMode(triggerPin, OUTPUT);
  digitalWrite(triggerPin, LOW);

  // pointer
  pinMode(led, OUTPUT);

  // drive train
  enableMotor();

  // battery condition
  pinMode(batteryPin, INPUT);
  
  // servos
  leftClaw.attach(leftClawPin);
  rightClaw.attach(rightClawPin);
  clawLift.attach(liftPin);
  setClaw(clawPos);
  clawLift.write(liftPos);
  pinMode(clawSensePin,INPUT);
  pinMode(liftSensePin,INPUT);
  
  // UART communication
  //Serial.begin(9600);
  Serial.begin(115200);  
} // setup

void loop() {
  // manage battery
  batteryVoltage=(5.0/1023)*analogRead(batteryPin)+0.4;
  Serial.print(batteryVoltage);
  Serial.print(" V | ");
  if (batteryVoltage<3.6) disableMotor();
  if (batteryVoltage>3.7) enableMotor();

  // measure distance to object ahead
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(100);
  digitalWrite(triggerPin, LOW);
  distance = pulseIn(echoPin, HIGH,30000)/58;
  Serial.print(distance);
  Serial.print(" cm | ");

  if ((distance>20)&&(distance<30)) 
    digitalWrite(led, HIGH);
  else
    digitalWrite(led, LOW);
  
  tNow=millis();
  // approach object
  if (distance>20) { // still in far approach
    velo=(signed char)constrain(distance*4,0,95);
    setLSpeed(velo-6); // compensate: L is faster than R
    setRSpeed(~velo);
    closeClaw=false;clawPos=1;setClaw(clawPos); // open claw
    lifted=false;liftClaw(0);
  }
  else {
    // pulse to approach object closely
    if ((millis()&0x0080)&&(!closeClaw))
      velo=70;
    else
      velo=0;
    setLSpeed(velo);
    setRSpeed(~velo);
    } 

  //
  if (closeClaw) {
    grip=squeezeClaw(600);
    if (grip<500) tRef=tNow; // not squeezing hard enough yet
    if ((!lifted)&&(tNow-tRef>1000)) { // squeezed stably long enough => lift
      weight=liftClaw(100);
      tRef=tNow;
      lifted=true;
    }
    if ((lifted)&&(tNow-tRef>2000)) { // lifted long enough: put down
      liftClaw(0);
      if (clawLift.read()==liftPos) {
        lifted=false;
        clawPos=0;setClaw(clawPos);
        closeClaw=false;
        tRef=tNow;
      }
    }
    Serial.print(weight);
    Serial.print(" weight | ");
    Serial.print(tNow-tRef);
  }
  else { // claw opened: close if close enough
    if (distance>8) tRef=tNow; // reset waiting
    else closeClaw=tNow-tRef>200; // long enough close enough to start closing the claw
  }
  handleLift();
Serial.println();
} // loop

void setClaw(int pos) {
  leftClaw.writeMicroseconds(2100-pos);
  rightClaw.writeMicroseconds(400+pos);
} // setClaw

int squeezeClaw(int target) {
// close the claw with target force (0 ... 1023)
// return actual force
  const int Hysteresis = 50;
  static int LoopCtr;
  int actual = analogRead(clawSensePin);

  Serial.print(actual);
  Serial.print(" grip | ");
  if (actual<target-Hysteresis) clawPos+=1; // close further
  if (!(LoopCtr&0x000f)&&(actual>target+Hysteresis)) clawPos-=1; // reopen slowly
  clawPos=constrain(clawPos,1,1800);
  setClaw(clawPos);
  LoopCtr++;
  return(actual);
} // squeezeClaw 

int liftClaw(int target) {
  // returns weight of lifted object
  // inaccurate immediately after pos has changed
  liftPos=constrain(target,0,100); // take physical limitation into account
  int actual = analogRead(liftSensePin);
  return(actual);
}

void handleLift() {
  // handle slow movement of the lift
  // call once per loop; required to avoid blocking calls
  static unsigned long tLast;
  int currentPos=clawLift.read();
  if (millis()-tLast>10) {
    if (liftPos>currentPos) clawLift.write(currentPos+1);
    if (liftPos<currentPos) clawLift.write(currentPos-1);
    tLast=millis();
  }
}

void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read(); 
  }
}

void disableMotor() {
  pinMode(dirR, INPUT);
  pinMode(pwmR, INPUT); 
  pinMode(dirL, INPUT);
  pinMode(pwmL, INPUT); 
}

void enableMotor() {
  pinMode(dirR, OUTPUT);
  pinMode(pwmR, OUTPUT); 
  pinMode(dirL, OUTPUT);
  pinMode(pwmL, OUTPUT);
}

void setLSpeed(signed char velo) {
// negative value means backward
  boolean dir = velo&0x80;
  velo<<=1;
  if (velo==0xFE) velo=0xFF;
  analogWrite(pwmL, velo);
  digitalWrite(dirL, dir);
}

void setRSpeed(signed char velo) {
// negative value means backward
  boolean dir = velo&0x80;
  velo<<=1;
  if (velo==0xFE) velo=0xFF;
  analogWrite(pwmR, velo);
  digitalWrite(dirR, dir);
}

