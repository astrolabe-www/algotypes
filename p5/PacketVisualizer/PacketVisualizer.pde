String DATA_TX_DIRECTORY = "../../Packets/out/2022-04-26";
String DATA_RX_FILENAME = "../../Packets/in/data_20220402-2248.raw";

int minV = 256;
int maxV = -1;

int OUT_SCALE = 3;
int PACKETS_PER_ROW = 64;

PGraphics opg;

void drawBytes(int[] data, PGraphics pg, float minV, float maxV) {
  pg.beginDraw();
  pg.background(255);
  pg.stroke(0);
  pg.strokeWeight(1);
  pg.noFill();

  float packetWidth = pg.width / float(PACKETS_PER_ROW);
  int numRows = ceil(pg.height / packetWidth);

  for (int i = 0; i < PACKETS_PER_ROW * numRows; i++) {
    float s = map(data[i % data.length], minV, maxV, 0.08, 1);

    int xi = (i % PACKETS_PER_ROW);
    int yi = (i / PACKETS_PER_ROW) % numRows;

    PVector center = new PVector(
      xi * packetWidth + packetWidth / 2.0, 
      yi * packetWidth + packetWidth / 2.0
      );

    int pad = 1;
    PVector[] corners = {
      new PVector(center.x - (s * packetWidth) / 2 + pad, center.y - (s * packetWidth) / 2 + pad), 
      new PVector(center.x + (s * packetWidth) / 2 - pad, center.y - (s * packetWidth) / 2 + pad), 
      new PVector(center.x + (s * packetWidth) / 2 - pad, center.y + (s * packetWidth) / 2 - pad), 
      new PVector(center.x - (s * packetWidth) / 2 + pad, center.y + (s * packetWidth) / 2 - pad)
    };

    pg.line(corners[0].x, corners[0].y, corners[1].x, corners[1].y);
    pg.line(corners[2].x, corners[2].y, corners[1].x, corners[1].y);
    pg.line(corners[2].x, corners[2].y, corners[3].x, corners[3].y);
    pg.line(corners[0].x, corners[0].y, corners[3].x, corners[3].y);
  }
  pg.endDraw();
}

void setup() {
  size(720, 720);
  noLoop();

  File[] dataFiles = new File(sketchPath(DATA_TX_DIRECTORY)).listFiles();
  opg = initPGraphics(opg, OUT_SCALE * width, OUT_SCALE * height);

  for (int i = 0; i < dataFiles.length; i++) {
    if (dataFiles[i].getName().endsWith(".raw")) {
      String algorithmName = dataFiles[i].getName().replace(".raw", "");
      String rawFilename = DATA_TX_DIRECTORY + File.separatorChar + algorithmName + ".raw";

      minV = 256;
      maxV = -1;
      int[] mData = loadBytesFromFile(rawFilename);

      drawBytes(mData, opg, minV, maxV);
      opg.save(sketchPath(
        "data" +
        File.separatorChar +
        PACKETS_PER_ROW +
        "_norm_sq" +
        File.separatorChar +
        algorithmName +
        ".jpg")
        );
    }
  }
  exit();
}

void draw() {
}
