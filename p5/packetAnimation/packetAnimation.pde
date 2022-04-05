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

int COLOR_BACKGROUND = color(0);
int COLOR_FRAME = color(16);
int COLOR_FOREGROUND_ALPHA = 128;
int COLOR_FOREGROUND_PRIMARY = color(200, COLOR_FOREGROUND_ALPHA);
int COLOR_FOREGROUND_RED = color(200, 0, 0, COLOR_FOREGROUND_ALPHA);
int COLOR_FOREGROUND_BLUE = color(8, 128, 255, COLOR_FOREGROUND_ALPHA);

void setup() {
  size(469, 804);
  initInput();

  mpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  mpg.smooth(8);
  mpg.beginDraw();
  mpg.background(COLOR_BACKGROUND, 255);
  mpg.endDraw();

  bpg = createGraphics(OUT_SCALE * width, OUT_SCALE * height);
  bpg.smooth(8);
  bpg.beginDraw();
  bpg.background(COLOR_BACKGROUND, 0);
  bpg.endDraw();

  drawBorders(bpg, BORDER_WIDTH);
}

void draw() {
  background(COLOR_BACKGROUND);
  drawInput(mpg);
  image(mpg, 0, 0, width, height);
  image(bpg, 0, 0, width, height);
}

int mouseIndex = 0;
int[] mouseClicks = {-1, -1, -1, -1};
long lastClick = 0;

void mouseReleased() {
  if ((mouseX < width / 2) && (mouseY < height / 2)) mouseClicks[mouseIndex] = 0;
  else if((mouseX > width / 2) && (mouseY < height / 2)) mouseClicks[mouseIndex] = 1;
  else if((mouseX < width / 2) && (mouseY > height / 2)) mouseClicks[mouseIndex] = 2;
  else mouseClicks[mouseIndex] = 3;
  mouseIndex = (mouseIndex + 1) % mouseClicks.length;

  if(millis() - lastClick > 500) mouseClicks[3] = mouseClicks[2] = mouseClicks[1] = -1;

  lastClick = millis();

  if((mouseClicks[1] == -1) || (mouseClicks[2] == -1) || (mouseClicks[3] == -1)) return;
  if(mouseClicks[0] == mouseClicks[1] || mouseClicks[0] == mouseClicks[2]) return;
  if(mouseClicks[1] == mouseClicks[2] || mouseClicks[1] == mouseClicks[3]) return;
  if(mouseClicks[3] == mouseClicks[0] || mouseClicks[3] == mouseClicks[2]) return;
  exit();
}
