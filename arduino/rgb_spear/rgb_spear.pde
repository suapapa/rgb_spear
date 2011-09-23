// This is just a mockup sketch for test scons works

#define PIN_L 13
#define PIN_R 10
#define PIN_G 9
#define PIN_B 11

byte currR, currG, currB;
byte newR, newG, newB;

void testLEDs(void);
byte char2dec(byte ch);
void transitionLED(int pin, byte *currV, byte newV);

#define PIN_BUZZ 2
void __buzz(int targetPin, long frequency, long length);
#define buzz(__freq__, __len__) __buzz(PIN_BUZZ, __freq__, __len__)

#define MODE_TRANSITION 0
#define MODE_ON 1
byte onMode;

void setup(void)
{
  pinMode(PIN_L, OUTPUT);
  pinMode(PIN_R, OUTPUT);
  pinMode(PIN_G, OUTPUT);
  pinMode(PIN_B, OUTPUT);

  onMode = MODE_TRANSITION;

  currR = 0; currG = 0; currB = 0;
  newR = 0; newG = 0; newB = 0;

  Serial.begin(9600);

  // buzz at 1500Hz for 500 milliseconds
  buzz(1500, 100);

  testLEDs();
}

byte high, low;
#define readColor(__color__) \
    high = char2dec(Serial.read());\
    low = char2dec(Serial.read());\
    __color__ = (high << 4) + low\

void loop(void)
{
  byte cmd;
  if (Serial.available() > 0) {
    digitalWrite(PIN_L, HIGH);

    cmd = Serial.read();
    if ('$' == cmd)
      onMode = MODE_TRANSITION;
    else if ('#' == cmd)
      onMode = MODE_ON;
    else {
      buzz(1500, 100);
      goto exit_loop;
    }

    // Wait for 6 chars
    for(int i = 0; i < 3; i++) {
      if (Serial.available() >= 6)
        break;
      delay(5);
    }

    if (Serial.available() >= 6) {
      readColor(newR);
      readColor(newG);
      readColor(newB);
    }
    digitalWrite(PIN_L, LOW);
  }

  switch(onMode) {
    case MODE_TRANSITION:
      transitionLED(PIN_R, &currR, newR);
      transitionLED(PIN_G, &currG, newG);
      transitionLED(PIN_B, &currB, newB);
      break;
    case MODE_ON:
      analogWrite(PIN_R, newR); currR = newR;
      analogWrite(PIN_G, newG); currG = newG;
      analogWrite(PIN_B, newB); currB = newB;
      break;
  }

exit_loop:
  delay(10);
}

void testLEDs(void)
{
#define blink(__pin__, __time__) \
  digitalWrite(__pin__, HIGH);\
  delay(__time__);\
  digitalWrite(__pin__, LOW)

  blink(PIN_L, 500);
  blink(PIN_R, 500);
  blink(PIN_G, 500);
  blink(PIN_B, 500);
}

byte char2dec(byte ch)
{
    if ('0' <= ch && ch <= '9')
        return ch - '0';

    ch &= ~0x20; // to upper case
    if ('A' <= ch && ch <= 'Z')
        return 10 + (ch - 'A');

    return 0;
}

void transitionLED(int pin, byte *currV, byte newV)
{
  if (*currV == newV)
    return;

  *currV += (*currV > newV) ? (-1) : (1);

  analogWrite(pin, *currV);
}

void __buzz(int buzzPin, long frequency, long length) {
  pinMode(buzzPin, OUTPUT);
  long delayValue = 1000000/frequency/2;
  long numCycles = frequency * length/ 1000;
  for (long i=0; i < numCycles; i++) {
    digitalWrite(buzzPin,HIGH);
    delayMicroseconds(delayValue);
    digitalWrite(buzzPin,LOW);
    delayMicroseconds(delayValue);
  }
}
/* vim: set sw=2 et: */
