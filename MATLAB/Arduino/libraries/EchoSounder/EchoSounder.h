#ifndef EchoSounder_h
#define EchoSounder_h

#include "Arduino.h"

/* REMARK: I had to define the interrupt routine at a global level. Is there a way to make it a method of the class ?
I have to make all sorts of private stuff public to define a global interrupt routine that does the job. */

#define SOUNDER_BUFF_LEN 3 // median filter length; an odd nbr; must be 3 (see distance() )
#define SOUNDER_WAIT 30000 // minimal delay between echo soundings (in us)
class EchoSounder {
public:
  EchoSounder(const int triggerPin, const int echoPin);
  void handler(); // call regularly
  void echoReceived();
  unsigned int distance(); // in cm
  volatile int _idx;
  volatile unsigned int _buff[SOUNDER_BUFF_LEN];
  volatile unsigned long _tLast;  // time of last echosounding (in us)
  boolean _uptodate;
private:
  unsigned int _distance;
  int _triggerPin;
};

#endif