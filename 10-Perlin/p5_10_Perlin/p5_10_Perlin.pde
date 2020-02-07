// Based on:
// https://en.wikipedia.org/wiki/Perlin_noise

// input
static final int SIZE_INPUT_NOISE = 4096 * 3;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

void initInput() {
  noiseDetail(4);
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

Perlin mPerlin;

void setup() {
  size(469, 804);
  noLoop();
}

void draw() {
  initInput();
  mPerlin = new Perlin(INPUT_NOISE);

  background(255);
  rectMode(CENTER);
  noiseDetail(1);
  noStroke();

  int c;
  int r = 3;

  for (float x = 0; x < width+r; x += r) {
    for (float y = 0; y < height+r; y += r) {
      //c = int(255f * noise(x/10f, y/10f));
      c = int(255f * mPerlin.noise(x/100f, y/100f));

      fill(c);
      rect(x, y, r+1, r+1);
    }
  }
  delay(100);
}
