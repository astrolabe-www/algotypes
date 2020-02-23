// input
String[] INPUT_FILENAME = {
  "in/frames_20200207-0004_reqs.raw",
  "out/0x00_PRNG.raw",
  "out/0x0A_Perlin_Noise.raw",
  "out/0x13_Primality_Test.raw"
};
int[] INPUT;

void initInput() {
  byte in[] = loadBytes(sketchPath("../../Packets/" + INPUT_FILENAME[0]));
  INPUT = new int[in.length];
  for (int i = 0; i < INPUT.length; i++) {
    INPUT[i] = in[i] & 0xff;
  }
}

PGraphics bpg;
PGraphics mpg;

int OUT_SCALE = 2;
int BORDER_WIDTH = 16;

void setup() {
  size(469, 804);
  initInput();

  mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255, 255);
  mpg.endDraw();

  bpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  bpg.smooth(8);
  bpg.beginDraw();
  bpg.background(255, 0);
  bpg.endDraw();

  drawBorders(bpg, OUT_SCALE * BORDER_WIDTH);
}

void draw() {
  background(255);
  drawInput(mpg);
  image(mpg, 0, 0, width, height);
  image(bpg, 0, 0, width, height);
}
