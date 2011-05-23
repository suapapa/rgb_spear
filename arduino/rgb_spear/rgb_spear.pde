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

void setup(void)
{
  pinMode(PIN_L, OUTPUT);
  pinMode(PIN_R, OUTPUT);
  pinMode(PIN_G, OUTPUT);
  pinMode(PIN_B, OUTPUT);

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
  if (Serial.available() > 0 && '#' == Serial.read()) {
    digitalWrite(PIN_L, HIGH);
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

  transitionLED(PIN_R, &currR, newR);
  transitionLED(PIN_G, &currG, newG);
  transitionLED(PIN_B, &currB, newB);

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
