void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  for (int i = 0; i < 3; i++) {
    blink(100);
  }
  delay(150);

  for (int i = 0; i < 3; i++) {
    blink(300);
  }

  for (int i = 0; i < 3; i++) {
    blink(100);
  }
  delay(500);
}

void blink(int delay_ms) {
  digitalWrite(LED_BUILTIN, LOW);
  delay(delay_ms);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(delay_ms);
}
