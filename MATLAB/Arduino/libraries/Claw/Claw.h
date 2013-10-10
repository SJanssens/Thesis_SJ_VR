#include "Servo.h"

#ifndef Claw_h
#define Claw_h

#include "Arduino.h"

#define MIN_LIFT 0
#define MAX_LIFT 100
#define SQUEEZE_HYST 50

class Claw
{
  public:
    Claw(int leftClawPin, int rightClawPin, int liftPin, int clawSensePin, int liftSensePin);
    void init(); // call in steup{} - workaround for arduino bug
    int lift(int target);
        // returns weight of lifted object
        // inaccurate immediately after target has changed
    boolean liftComplete(); // true iff actual lift position attained target
    boolean isLifted();
    boolean squeezeComplete(); // true iff actual squeezing force above target
    boolean isOpen();
    int squeeze(int target);
        // squeeze with a target force. Actual force returned.
    void open();
        // open the claw
    void handler();
        // call once per loop; required to avoid blocking calls
  private:
    Servo leftClaw;
    Servo rightClaw;
    Servo clawLift;
    int _clawPos;
    int _liftPos;
    int _squeezeForce;
    int _liftSensePin;
    int _clawSensePin;
    int _leftClawPin;
    int _rightClawPin;
    int _liftPin;
    unsigned long _tLast;
    void setClaw(int pos);
};

#endif

