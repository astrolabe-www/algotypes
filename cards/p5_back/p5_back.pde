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

void draw() {
  background(255);
  image(drawInputFramesToGraphics(INPUT_FRAMES), 0, 0);
  drawBorders(10);
}
