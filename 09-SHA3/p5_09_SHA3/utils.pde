import java.util.Arrays;

void drawInputFrames(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(INPUT_FRAMES[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(INPUT_FRAMES[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT_FRAMES[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg, int bwidth) {
  Keccak mKeccak = new Keccak(576, 1024);

  mpg.beginDraw();
  mpg.stroke(200, 0, 0, 2);

  for (int i = 0; i < SIZE_INPUT_FRAMES / 64; i++) {
    byte[] iiin = Arrays.copyOfRange(INPUT_FRAMES, i * 64, (i + 1) * 64);
    byte[] iout = mKeccak.SHA3(iiin);

    for (int j = 0; j < min(iiin.length, iout.length); j++) {
      float iiinY = map(iiin[j], -128, 0x7f, bwidth, mpg.width - bwidth);
      float ioutY = map(iout[j], -128, 0x7f, bwidth, mpg.width - bwidth);
      for (int k = -6; k <= 6; k++) {
        mpg.line(k + iiinY, mpg.height - bwidth, k + ioutY, bwidth);
      }
    }
  }
  mpg.endDraw();
}

void drawBorders(PGraphics mpg, int bwidth) {
  mpg.beginDraw();
  mpg.rectMode(CORNER);
  mpg.stroke(255);
  mpg.fill(255);
  mpg.rect(0, 0, mpg.width, bwidth);
  mpg.rect(0, mpg.height - bwidth, mpg.width, bwidth);
  mpg.rect(0, 0, bwidth, mpg.height);
  mpg.rect(mpg.width - bwidth, 0, bwidth, mpg.height);

  mpg.noFill();
  mpg.stroke(10);
  mpg.strokeWeight(1);
  mpg.rect(1, 1, mpg.width - 2, mpg.height - 2);
  mpg.endDraw();
}



String hexString(byte[] b) {
  String s = "";
  for (int i = 0; i < b.length; i++) {
    s += String.format("%02x", b[i]);
  }
  return s;
}
