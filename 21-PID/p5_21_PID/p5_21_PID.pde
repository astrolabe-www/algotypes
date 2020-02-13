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

void draw() {
  mPID = new PID(INPUT_FRAMES);
  println(mPID.getError());

  //beginRecord(PDF, "filename.pdf");
  background(255);

  drawInputFrames();
  drawOutput();
  drawBorders(10);
  //endRecord();
}
