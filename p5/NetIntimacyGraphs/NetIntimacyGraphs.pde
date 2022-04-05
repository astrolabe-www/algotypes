PGraphics mGraph;
float[] mHeart;
float[] mTemp;
float[] mWifi;

int POINTS_PER_SCREEN = 90;

void setup() {
  size(960, 540);
  smooth();
  noLoop();
  noiseSeed(101081);

  mGraph = createGraphics(2 * width, 2 * height);
  mHeart = new float[2 * mGraph.width];
  mTemp = new float[2 * mGraph.width];
  mWifi = new float[2 * mGraph.width];

  for (int i = 0; i < mHeart.length; i++) {
    mHeart[i] = (i < POINTS_PER_SCREEN) ? 0 : 0.25 + 0.333 * (noise(i / 4f) - 0.5);
    mTemp[i] = (i < POINTS_PER_SCREEN) ? 0 : 0.1 + 0.333 * (noise(i / 16f, PI) - 0.5);
  }

  int AVG_LENGTH = 4;
  byte in[] = loadBytes(sketchPath("../../Packets/in/frames_20200207-0006_beacons.raw"));
  for (int i = 0; i < mWifi.length; i++) {
    int sum = 0;

    for (int j = AVG_LENGTH - 1; j >= 0; j--) {
      int mi = (i - j + mWifi.length) % mWifi.length;
      sum += in[mi % in.length] & 0xff;
    }
    mWifi[i] = (i < POINTS_PER_SCREEN) ? 0 : map(sum / AVG_LENGTH, 0, 256, 0, .666);
  }

  for(int i = 0; i < 2 * POINTS_PER_SCREEN; i ++) {
    if(i % 10 == 0) println(i);
    String fname = "graph_" + ((i < 100) ? "0" : "") + ((i < 10) ? "0" : "") + i;
    drawGraphs(i);
    mGraph.save(dataPath("out/" + fname + ".png"));
  }
}

void drawSignal(float[] mSignal, PGraphics mpg, int offset, color mc) {
  mpg.beginDraw();
  mpg.beginShape();

  mpg.stroke(mc);
  for (int i = 0; i < POINTS_PER_SCREEN; i++) {
    float mx = map(i, 0, POINTS_PER_SCREEN, 0, mpg.width);
    float my = map(mSignal[i + offset], 0, 1, 0.95 * mpg.height, 0.05 * mpg.height);
    mpg.vertex(mx, my);
  }

  mpg.endShape();
  mpg.endDraw();
}

void drawGraphs(int offset) {
  mGraph.beginDraw();
  mGraph.smooth();
  mGraph.background(255, 0);
  mGraph.strokeWeight(4);
  mGraph.noFill();
  mGraph.endDraw();

  drawSignal(mWifi, mGraph, offset, color(255, 200));
  drawSignal(mHeart, mGraph, offset, color(255, 200));
  drawSignal(mTemp, mGraph, offset, color(255, 200));
}

void draw() {
  background(100);
  image(mGraph, 0, 0, width, height);
}
