#include "EchoSounder.h"

EchoSounder::EchoSounder(const int triggerPin,const int echoPin) {
// echoPin must be an external interrupt pin (2 or 3 on an Uno)
  pinMode(echoPin, INPUT);
  pinMode(triggerPin, OUTPUT);
  digitalWrite(triggerPin, LOW);
  _triggerPin=triggerPin;
  for (_idx=SOUNDER_BUFF_LEN;_idx>0;) _buff[--_idx]=0;
  _tLast=micros();
  _distance=0;
  _uptodate=false;
}

void EchoSounder::handler() {
  if ((micros()-_tLast)>SOUNDER_WAIT) {
    digitalWrite(_triggerPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(_triggerPin, LOW);
    _tLast=micros();
  }
}

unsigned int EchoSounder::distance() {
// sort only valid for SOUNDER_BUFF_LEN == 3
// there are only 6 possible orderings
  if (!_uptodate) {
    _uptodate=true;
    if ((_buff[0]<=_buff[1])&&(_buff[0]>=_buff[2])) {_distance=_buff[0]/58-9;return(_distance);}
    if ((_buff[0]>=_buff[1])&&(_buff[0]<=_buff[2])) {_distance=_buff[0]/58-9;return(_distance);}
    if ((_buff[1]<=_buff[0])&&(_buff[1]>=_buff[2])) {_distance=_buff[1]/58-9;return(_distance);}
    if ((_buff[1]>=_buff[0])&&(_buff[1]<=_buff[2])) {_distance=_buff[1]/58-9;return(_distance);}
    if ((_buff[2]<=_buff[0])&&(_buff[2]>=_buff[1])) {_distance=_buff[2]/58-9;return(_distance);}
    if ((_buff[2]>=_buff[0])&&(_buff[2]<=_buff[1])) {_distance=_buff[2]/58-9;return(_distance);}
  } else return(_distance);
}