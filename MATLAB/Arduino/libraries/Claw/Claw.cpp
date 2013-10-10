#include <Servo.h>

//#include "Arduino.h"
#include "Claw.h"


Claw::Claw(int leftClawPin, int rightClawPin, int liftPin,
         int clawSensePin, int liftSensePin) {
  pinMode(clawSensePin,INPUT);
  pinMode(liftSensePin,INPUT);
  _clawSensePin=clawSensePin;
  _liftSensePin=liftSensePin;

  _leftClawPin=leftClawPin;
  _rightClawPin=rightClawPin;
  _liftPin=liftPin;
  
  _tLast=millis();
} // Claw

void Claw::init() {
  /* attach cannot be dune during Claw constructor.
     Therfore, this init routine is required. */
  leftClaw.attach(_leftClawPin);
  rightClaw.attach(_rightClawPin);
  clawLift.attach(_liftPin);
  _clawPos=1;setClaw(_clawPos);
  _liftPos=0;this->clawLift.write(_liftPos);
} // init

void Claw::setClaw(int pos) {
  leftClaw.writeMicroseconds(2000-pos);
  rightClaw.writeMicroseconds(500+pos);
} // setClaw

void Claw::open() {
  _clawPos=1;
  setClaw(_clawPos);
  _squeezeForce=0;
} // open

boolean Claw::liftComplete() {
  return(clawLift.read()==_liftPos);
} // liftComplete

boolean Claw::squeezeComplete() {
  int actual = analogRead(_clawSensePin);
  return(actual>_squeezeForce-SQUEEZE_HYST);
} // squeezeComplete

boolean Claw::isOpen() {
  return(_clawPos<5);
} // isOpen

boolean Claw::isLifted() {
  return(_liftPos!=MIN_LIFT);
} // isLifted

int Claw::lift(int target) {
  _liftPos=constrain(target,MIN_LIFT,MAX_LIFT); // take physical limitation into account
  return(analogRead(_liftSensePin));
}

int Claw::squeeze(int target) {
  _squeezeForce=target;
  return(analogRead(_clawSensePin));
}

/*
int Claw::squeeze(int target) {
  const int Hysteresis = 50;
  static int LoopCtr;
  int actual = analogRead(_clawSensePin);

  Serial.print(actual);
  Serial.print(" grip | ");
  if (actual<target-Hysteresis) _clawPos+=1; // close further
  if (!(LoopCtr&0x0007)&&(actual>target+Hysteresis)) _clawPos-=1; // reopen slowly
  _clawPos=constrain(_clawPos,1,1800);
  setClaw(_clawPos);
  LoopCtr++;
  return(actual);
} // squeeze
*/

void Claw::handler() {
  unsigned long tDelta=millis()-_tLast;
//  Serial.print(tDelta);
//  Serial.print(" ms | ");
  int currentPos=clawLift.read();
  int force=analogRead(_clawSensePin);
//  Serial.print(currentPos);
//  Serial.print(" ");
//  Serial.print(_liftPos);
//  Serial.print(" ");
//  Serial.print(force);
//  Serial.print(" ");
//  Serial.print(_squeezeForce);
//  Serial.print(" ");
  if (tDelta>30) {
    if (_liftPos>currentPos)
      clawLift.write(constrain(currentPos+(int)(tDelta/8),MIN_LIFT,_liftPos));
    if (_liftPos<currentPos)
      clawLift.write(constrain(currentPos-(int)(tDelta/15),_liftPos,MAX_LIFT));
    if (_squeezeForce>0) {
      if (force<_squeezeForce-SQUEEZE_HYST) _clawPos+=tDelta/4; // close further
      if (force>_squeezeForce+SQUEEZE_HYST) _clawPos-=1; // release slowly
      setClaw(_clawPos);
    } else {
      this->open();
    }
    _tLast=millis();
  }
} // handler

