#include "RotaryEncoder.h"

RotaryEncoder::RotaryEncoder(const int Apin, const int Bpin, const int intPin) {
  pinMode(Apin,INPUT_PULLUP);
  pinMode(Bpin,INPUT_PULLUP);
  pinMode(intPin,INPUT);
  attachInterrupt(0,Rhandle,CHANGE);  
}