// Based on:
// https://en.wikipedia.org/wiki/Primality_test
// https://en.wikipedia.org/wiki/Primality_test#Pseudocode

import java.util.Arrays;

// input
int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

String[] INPUT_FRAMES_FILENAME = {
  "frames_20200206-2351.raw",
  "frames_20200206-2357.raw",
  "frames_20200207-0004_reqs.raw",
  "frames_20200207-0006_beacons.raw",
  "frames_20200207-0008_data.raw",
  "frames_20200207-0010.raw",
  "frames_20200207-0012.raw"
};
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;
int BYTES_PER_PRIME = 2;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0x7fffffff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = new byte[0];

  for (int i = 0; i < INPUT_FRAMES_FILENAME.length; i++) {
    byte file[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME[i]));
    in = Arrays.copyOf(in, in.length + file.length);
    arraycopy(file, 0, in, in.length - file.length, file.length);
  }

  SIZE_INPUT_FRAMES = in.length / BYTES_PER_PRIME;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = 0x0;
    for (int b = 0; b < BYTES_PER_PRIME; b++) {
      int bi = (BYTES_PER_PRIME * i + b);
      INPUT_FRAMES[i] = INPUT_FRAMES[i] | ((in[bi] & 0xff) << (8 * (BYTES_PER_PRIME - 1 - b)));
    }
    INPUT_FRAMES[i] = (0x3fffffff >>> (8 * (4 - BYTES_PER_PRIME))) & INPUT_FRAMES[i];
  }
}

static class Card {
  static final public String number = "0x13";
  static final public String name = "Primes";
}

void setup() {
  size(469, 804);
  mFont = createFont("Ogg-Roman", OUT_SCALE * FONT_SIZE);
  noLoop();
  initInputNoise();
  initInputFrames();
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;
int FONT_SIZE = 32;
PFont mFont;

void draw() {
  background(255);

  PGraphics mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255);
  mpg.endDraw();

  drawInputFrames(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save("out.png");
  // mpg.save("out.jpg");

  image(mpg, 0, 0, width, height);
}
