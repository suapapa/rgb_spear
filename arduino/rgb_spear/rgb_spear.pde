// This is just a mockup sketch for test scons works

#define PIN_L 13
#define PIN_R 10
#define PIN_G 9
#define PIN_B 11

void test_run(void);

void setup(void)
{
  pinMode(PIN_L, OUTPUT);
  pinMode(PIN_R, OUTPUT);
  pinMode(PIN_G, OUTPUT);
  pinMode(PIN_B, OUTPUT);
}

void loop(void)
{
  test_run();
}

void test_run(void)
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

/* vim: set sw=2 et: */
