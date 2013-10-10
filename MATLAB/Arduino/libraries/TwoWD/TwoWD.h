#ifndef TwoWD_h
#define TwoWD_h

extern boolean doWrite;

class TwoWD {
public:
  TwoWD(int dirR,int pwmR,int dirL,int pwmL);
  // speed is -16384 ... 16383. Uses long to avoid overflow
  void straightContinuous(long speed); // negative is backwards
  void straightPulsed(long speed); // negative is backwards
  void setRefAngle(); // current orientation serves as reference
  void setRefAngle(float newRefAngle); // replace ref angle
  void enable();
  void disable();
  void handler(); // call regularly (control loop)
  float refAngle; // direction we should be heading or start of rotations
  float actualAngle; // direction we are heading
private:
  int _centerClip(int speed);
  void _setLSpeed(signed char velo);
  void _setRSpeed(signed char velo);
  char _pwmL;
  char _pwmR; // -128 ... 127 actual motor drive
  int _targetSpeed; // target speed
  int _actSpeed; // last measured speed
  int _speedOffset; // difference between L and R
  char _dirPinR;
  char _dirPinL;
  char _pwmPinR;
  char _pwmPinL;
  boolean _pulsed;
};

#endif

