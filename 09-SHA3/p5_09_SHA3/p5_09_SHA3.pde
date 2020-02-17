// Based on:
// https://keccak.team/keccak_specs_summary.html
// https://github.com/XKCP/XKCP/blob/master/Standalone/CompactFIPS202/Python/CompactFIPS202.py

import processing.pdf.*;

// input
int SIZE_INPUT_NOISE = 1024;
byte[] INPUT_NOISE = new byte[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
byte[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = byte(0xff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new byte[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = byte(in[i] & 0xff);
  }
}

Keccak mKeccak;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

int BORDER_WIDTH = 10;
void draw() {
  mKeccak = new Keccak(576, 1024);

  byte[] r = mKeccak.SHA3(INPUT_FRAMES);
  println(hexString(r));

  r = mKeccak.SHA3("hello world".getBytes());
  println(hexString(r));

  r = mKeccak.SHA3("hello world.".getBytes());
  println(hexString(r));

  //beginRecord(PDF, "filename.pdf");
  background(255);

  drawInputFrames();
  drawOutput(BORDER_WIDTH);
  drawBorders(BORDER_WIDTH);
  //endRecord();
}
