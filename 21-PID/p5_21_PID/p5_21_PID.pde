// Based on:
// https://en.wikipedia.org/wiki/PID_controller
// https://en.wikipedia.org/wiki/PID_controller#Discrete_implementation
// https://www.csimn.com/CSI_pages/PIDforDummies.html

import processing.pdf.*;

// input
int SIZE_INPUT_NOISE = 1024;
byte[] INPUT_NOISE = new byte[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = byte(0xff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  noiseSeed(1010);

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = int(in[i] * noise(i/100.0, frameCount));
  }
}

PID mPID;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;

void draw() {
  mPID = new PID(INPUT_FRAMES);
  println(mPID.getError());

  background(255);

  PGraphics mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255, 0);
  mpg.endDraw();

  drawInputFrames(mpg);
  drawOutput(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save("out.png");
  // mpg.save("out.jpg");

  image(mpg, 0, 0, width, height);
}
