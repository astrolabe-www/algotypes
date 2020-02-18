// input
String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length / 4;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
  }
}

void setup() {
  size(469, 804);
  noLoop();
  initInputFrames();
}

int OUT_SCALE = 10;
int BORDER_WIDTH = 10;

void draw() {
  background(255);

  PGraphics mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(255, 0);
  mpg.endDraw();

  drawInputFrames(mpg);
  drawBorders(mpg, OUT_SCALE * BORDER_WIDTH);
  // mpg.save("out.png");
  // mpg.save("out.jpg");

  image(mpg, 0, 0, width, height);
}
