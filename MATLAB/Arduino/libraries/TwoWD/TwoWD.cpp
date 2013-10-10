#include "Arduino.h"
#include "TwoWD.h"

TwoWD::TwoWD(int dirR,int pwmR,int dirL,int pwmL) {
  _dirPinR=dirR;
  _dirPinL=dirL;
  _pwmPinR=pwmR;
  _pwmPinL=pwmL;
  _pwmR=0;
  _pwmL=0;
  _pulsed=false;
  disable();
  refAngle=actualAngle=0.0;
} // TwoWD

int TwoWD::_centerClip(int speed) {
  speed=constrain(speed,-16383,16383);
  int aspeed=abs(speed);
  int mask=0;
  if (speed<0) mask=0xffff;
  if (aspeed<=1024) return(0);
  if (aspeed>4096) return(mask^((aspeed>>1)+8192));
  if (speed>1024) return(mask^((aspeed<<1)+2048));
}

void TwoWD::straightContinuous(long speed) {
  _targetSpeed=constrain(speed,-16383,16383);
  _pulsed=false;
}

void TwoWD::straightPulsed(long speed) {
  _targetSpeed=constrain(speed,-16383,16383);
  _pulsed=true;
}

void TwoWD::setRefAngle() {
  refAngle=actualAngle;
}

void TwoWD::setRefAngle(float newRefAngle){
  while (newRefAngle<=-180.0) newRefAngle+=360.0;
  while (newRefAngle>180.0) newRefAngle-=360.0;
  refAngle=newRefAngle;
}

void TwoWD::_setLSpeed(signed char velo) {
  // negative value means backward
  boolean dir = velo&0x80;
  velo<<=1;
  if (velo==0xFE) velo=0xFF;
  analogWrite(_pwmPinL, velo);
  digitalWrite(_dirPinL, dir);
}

void TwoWD::_setRSpeed(signed char velo) {
  // negative value means backward
  boolean dir = velo&0x80;
  velo<<=1;
  if (velo==0xFE) velo=0xFF;
  analogWrite(_pwmPinR, velo);
  digitalWrite(_dirPinR, dir);
}

void TwoWD::disable() {
  pinMode(_dirPinR, INPUT);
  pinMode(_pwmPinR, INPUT); 
  pinMode(_dirPinL, INPUT);
  pinMode(_pwmPinL, INPUT); 
}

void TwoWD::enable() {
  pinMode(_dirPinR, OUTPUT);
  pinMode(_pwmPinR, OUTPUT); 
  pinMode(_dirPinL, OUTPUT);
  pinMode(_pwmPinL, OUTPUT);
}

void TwoWD::handler() {
  float diff=actualAngle-refAngle;
  int spd;
  while (diff<=-180.0) diff+=360.0;
  while (diff>180.0) diff-=360.0;
  //_speedOffset=constrain((int)(200.0*diff),-5000,5000);
  _speedOffset=(int)constrain((long)(500.0*diff),-10000,10000);
  //if (doWrite) {Serial.print(diff);Serial.print(" diff | ");}
  //if (doWrite) {Serial.print(_speedOffset);Serial.print(" sOffs | ");}
  //if (doWrite) {Serial.print(_targetSpeed);Serial.print(" sTar | ");}
  spd=_centerClip(_targetSpeed-_speedOffset);
  //if (doWrite) {Serial.print(spd);Serial.print(" spdL | ");}
  _pwmL=spd>>7;
  //if (doWrite) {Serial.print((int)_pwmL);Serial.print(" pwmL | ");}
  spd=_centerClip(_targetSpeed+_speedOffset);
  //if (doWrite) {Serial.print(spd);Serial.print(" spdR | ");}
  _pwmR=spd>>7;
  //if (doWrite) {Serial.print((int)_pwmR);Serial.print(" pwmR | ");}
  if ((!_pulsed)||(millis()&0x0080)) {
    _setLSpeed(_pwmL);
    _setRSpeed(~_pwmR);
  }
  else {
    _setLSpeed(0);
    _setRSpeed(0);
  }
}


