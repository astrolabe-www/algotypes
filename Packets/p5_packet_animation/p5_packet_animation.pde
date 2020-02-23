// input
String[] INPUT_FILENAME = {
  "in/frames_20200207-0004_reqs.raw",
  "out/0x00_PRNG.raw",
  "out/0x0A_Perlin_Noise.raw",
  "out/0x13_Primality_Test.raw"
};
int[][] INPUT;

void initInput() {
  INPUT = new int[INPUT_FILENAME.length][];
  for (int i = 0; i < INPUT_FILENAME.length; i++) {
    byte in[] = loadBytes(sketchPath("../../Packets/" + INPUT_FILENAME[i]));
    INPUT[i] = new int[in.length];
    for (int b = 0; b < INPUT[i].length; b++) {
      INPUT[i][b] = in[b] & 0xff;
    }
  }
}

PGraphics bpg;
PGraphics mpg;

int OUT_SCALE = 1;
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
