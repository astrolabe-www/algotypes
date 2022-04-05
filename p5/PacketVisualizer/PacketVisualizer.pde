String DATA_OUT_DIRECTORY = "../../Packets/out/2022-04-04";
String DATA_IN_FILENAME = "../../Packets/in/data_20220402-2248.raw";

int[] DATA_IN;
int[] DATA_OUT;

int COLOR_BACKGROUND = color(0);
int COLOR_FRAME = color(16);
int COLOR_FOREGROUND_ALPHA = 200;
int COLOR_FOREGROUND_DATA_IN = color(200, COLOR_FOREGROUND_ALPHA);
int COLOR_FOREGROUND_DATA_OUT = color(200, 0, 0, COLOR_FOREGROUND_ALPHA);

int OUT_SCALE = 1;
int PACKETS_PER_ROW = 48;

PGraphics dipg;
PGraphics dopg;
PGraphics opg;

int[] loadBytesFromFile(String filename, int[] bytes) {
  byte data[] = loadBytes(sketchPath(filename));
  bytes = new int[data.length];
  for (int b = 0; b < bytes.length; b++) {
    bytes[b] = data[b] & 0xff;
  }
  return bytes;
}

PGraphics initPGraphics(PGraphics pg, int w, int h) {
  pg = createGraphics(w, h);
  pg.smooth(8);
  pg.beginDraw();
  pg.background(COLOR_BACKGROUND, 255);
  pg.endDraw();
  return pg;
}

void drawToOutputGraphics() {
  opg.beginDraw();
  opg.image(dipg, 0, 0, opg.width/2, opg.height);
  opg.image(dopg, opg.width/2, 0, opg.width/2, opg.height);
  opg.endDraw();
}

void loadData(String outFilename) {
  DATA_IN = loadBytesFromFile(DATA_IN_FILENAME, DATA_IN);
  DATA_OUT = loadBytesFromFile(outFilename, DATA_OUT);
}

void initGraphics() {
  dipg = initPGraphics(dipg, OUT_SCALE * width / 2, OUT_SCALE * height);
  dopg = initPGraphics(dopg, OUT_SCALE * width / 2, OUT_SCALE * height);
  opg = initPGraphics(opg, OUT_SCALE * width, OUT_SCALE * height);
}

void drawBytes(int[] data, PGraphics pg, color mc) {
  pg.beginDraw();
  pg.rectMode(CENTER);
  pg.noStroke();
  pg.fill(mc);

  int packetWidth = ceil(pg.width / PACKETS_PER_ROW);
  int numRows = ceil(pg.height / float(packetWidth));
  int maxLayers = 1;

  for (int i = 0; i < data.length; i++) {
    float s = map(data[i], 0, 256, 0.08, 1);

    int xi = (i % PACKETS_PER_ROW);
    int yi_raw = (i / PACKETS_PER_ROW); 
    int yi = (yi_raw) % numRows;

    if (yi_raw < maxLayers * numRows) {
      pg.pushMatrix();
      pg.translate(packetWidth / 2, packetWidth / 2);
      pg.rect(xi * packetWidth, yi * packetWidth, s * packetWidth, s * packetWidth);
      pg.popMatrix();
    }
  }
  pg.endDraw();
}

void setup() {
  size(960, 800);
  noLoop();

  File[] DATA_OUT_FILES = new File(sketchPath(DATA_OUT_DIRECTORY)).listFiles();

  for (int i = 0; i < DATA_OUT_FILES.length; i++) {
    String algorithmName = DATA_OUT_FILES[i].getName().replace(".raw", "");
    String dataOutFilename = DATA_OUT_DIRECTORY + "/" + algorithmName + ".raw";

    loadData(dataOutFilename);
    initGraphics();

    drawBytes(DATA_IN, dipg, COLOR_FOREGROUND_DATA_IN);
    drawBytes(DATA_OUT, dopg, COLOR_FOREGROUND_DATA_OUT);
    drawToOutputGraphics();
  }

  image(opg, 0, 0, width, height);
}

void draw() {
}
