int[] loadBytesFromFile(String filename, int[] bytes) {
  byte data[] = loadBytes(sketchPath(filename));
  bytes = new int[data.length];
  minV = 256;
  maxV = -1;
  for (int b = 0; b < bytes.length; b++) {
    bytes[b] = data[b] & 0xff;
    minV = (bytes[b] < minV) ? bytes[b] : minV;
    maxV = (bytes[b] > maxV) ? bytes[b] : maxV;
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
