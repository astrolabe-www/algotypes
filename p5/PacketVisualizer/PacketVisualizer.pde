String DATA_OUT_DIRECTORY = "../../Packets/out/2022-04-26";
String DATA_IN_FILENAME = "../../Packets/in/data_20220402-2248.raw";

int[] DATA_IN;
int[] DATA_OUT;

int minV = 256;
int maxV = -1;

int COLOR_BACKGROUND = color(0);
int COLOR_FRAME = color(16);
int COLOR_FOREGROUND_ALPHA = 200;
int COLOR_FOREGROUND_DATA_IN = color(200, COLOR_FOREGROUND_ALPHA);
int COLOR_FOREGROUND_DATA_OUT = color(200, 0, 0, COLOR_FOREGROUND_ALPHA);

int OUT_SCALE = 1;
int PACKETS_PER_ROW = 64;

PGraphics dipg;
PGraphics dopg;
PGraphics opg;

void drawBytes(int[] data, PGraphics pg, color mc, float minV, float maxV) {
  pg.beginDraw();
  pg.rectMode(CENTER);
  pg.noStroke();
  pg.fill(mc);

  float packetWidth = pg.width / float(PACKETS_PER_ROW);
  int numRows = ceil(pg.height / packetWidth);
  int maxLayers = 1;

  for (int i = 0; i < PACKETS_PER_ROW * numRows; i++) {
    float s = map(data[i % data.length], minV, maxV, 0.08, 1);

    int xi = (i % PACKETS_PER_ROW);
    int yi_raw = (i / PACKETS_PER_ROW);
    int yi = (yi_raw) % numRows;

    if (yi_raw < maxLayers * numRows) {
      pg.pushMatrix();
      pg.translate(packetWidth / 2.0, packetWidth / 2.0);
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
    if (DATA_OUT_FILES[i].getName().endsWith(".raw")) {
      String algorithmName = DATA_OUT_FILES[i].getName().replace(".raw", "");
      String dataOutFilename = DATA_OUT_DIRECTORY + "/" + algorithmName + ".raw";

      loadData(dataOutFilename);
      initGraphics();

      drawBytes(DATA_IN, dipg, COLOR_FOREGROUND_DATA_IN, 0, 256);
      drawBytes(DATA_OUT, dopg, COLOR_FOREGROUND_DATA_OUT, minV, maxV);
      drawToOutputGraphics();
      opg.save(sketchPath("data/" + PACKETS_PER_ROW + "_norm/" + algorithmName + ".jpg"));
    }
  }
  exit();
}

void draw() {
}
