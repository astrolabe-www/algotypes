// Based on:
// http://pi.math.cornell.edu/~web6140/TopTenAlgorithms/JPEG.html
// https://en.wikipedia.org/wiki/JPEG#Quantization
// https://en.wikipedia.org/wiki/JPEG#Discrete_cosine_transform

// input
final int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

final int[] TEST_INPUT = new int[] {
  52, 55, 61, 66, 70, 61, 64, 73, 
  63, 59, 55, 90, 109, 85, 69, 72, 
  62, 59, 68, 113, 144, 104, 66, 73, 
  63, 58, 71, 122, 154, 106, 70, 69, 
  67, 61, 68, 104, 126, 88, 68, 70, 
  79, 65, 60, 70, 77, 68, 58, 75, 
  85, 71, 64, 59, 55, 61, 65, 83, 
  87, 79, 69, 68, 65, 76, 78, 94
};

void initInput() {
  int INPUT_DIM = (int)sqrt(SIZE_INPUT_NOISE);
  for (int i=0; i < SIZE_INPUT_NOISE; i++) {
    float x = (i / INPUT_DIM) / 10.0f;
    float y = (i % INPUT_DIM) / 10.0f;
    INPUT_NOISE[i] = int(0xff * noise(x, y, frameCount));
  }
}

JFIF mJFIF;

void setup() {
  size(469, 804);
  noLoop();
  noiseSeed(0);

  byte in[] = loadBytes(sketchPath("../../esp8266/frames_20200206-2351.raw"));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];
  for (int i=0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = in[i] & 0xff;
  }
}

void draw() {
  initInput();

  mJFIF = new JFIF(INPUT_FRAMES);
  int[][] mjpeg = mJFIF.jpeg();
  int[][] mluminance = mJFIF.luminance();

  background(255);

  float w = float(width) / mJFIF.luminance[0].length;
  float h = float(height / 2) / mJFIF.luminance.length;

  for (int y=0; y<mjpeg.length; y++) {
    for (int x=0; x<mjpeg[y].length; x++) {
      fill(mluminance[y][x]);
      stroke(mluminance[y][x]);
      rect(w*x, h*y, w, h);

      fill(mjpeg[y][x]);
      stroke(mjpeg[y][x]);
      rect(w*x, (height/2)+h*y, w, h);
    }
  }
}

void testZigZagOrder() {
  stroke(255);
  textSize(14);
  textAlign(CENTER, CENTER);

  int xs = width / 8;
  int ys = height / 8;

  for (int y = 0; y < 8; y++) {
    for (int x = 0; x < 8; x++) {
      String n = Integer.toString(y*8+x);
      fill(255);
      text(n, x * xs, y * ys, xs, ys);
      noFill();
      rect(x * xs, y * ys, xs, ys);
    }
  }

  int c = 0;
  fill(220, 50, 50);
  for (int i = 0; i < 8; i++) {
    boolean up = ((i % 2) == 0);
    for (int j = 0; j <= i; j++) {
      int x = up ? j : i - j;
      int y = up ? i - j : j;
      String n = "\n\n" + Integer.toString(c++);
      text(n, x * xs, y * ys, xs, ys);
    }
  }

  for (int i = 1; i < 8; i++) {
    boolean up = ((i % 2) == 1);
    for (int j = 0; j <= (7 - i); j++) {
      int x = up ? i + j : (7 - j);
      int y = up ? (7 - j) : i + j;
      String n = "\n\n" + Integer.toString(c++);
      text(n, x * xs, y * ys, xs, ys);
    }
  }
}
