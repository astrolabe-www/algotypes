int[] loadBytesFromFile(String filename) {
  byte data[] = loadBytes(sketchPath(filename));
  int[] bytes = new int[data.length];
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
  pg.endDraw();
  return pg;
}
