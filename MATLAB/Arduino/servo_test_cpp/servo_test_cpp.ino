#include "Arduino.h"
#include <Servo.h>

class SlowServo {
  public:
    SlowServo(int pin);
    void init(); // call in setup() - workaround for arduino bug
    void write(int target); // set new target
    void handler(); // call regularly
  private:
    Servo FastServo;
    int _target;
    int _pin;
    unsigned long _tLast;
};

SlowServo::SlowServo(int pin) {
  //FastServo=new Servo;
  //FastServo.attach(pin);
  this->_pin=pin;
  this->_tLast=millis();
}

void SlowServo::init() {
  FastServo.attach(_pin);
}

void SlowServo::write(int target) {
  this->_target=target;
}

void SlowServo::handler() {
  int current;
  if (millis()-this->_tLast>10) { // max one degree per 10ms
    current=FastServo.read();
    if (_target>current) FastServo.write(current+1);
    if (_target<current) FastServo.write(current-1);
    this->_tLast=millis();
  } 
}

SlowServo myServo(8);
int ask=0;
unsigned long tRef;

void setup() {
  myServo.init();
  myServo.write(90);
  tRef=millis();
}

void loop() {
  myServo.handler();
  if ((millis()-tRef)>3000) {
    if (ask) ask=0; else ask=180;
    myServo.write(ask);
    tRef=millis();
  }
}

