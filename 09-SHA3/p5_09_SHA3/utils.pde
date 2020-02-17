import java.util.Arrays;

void drawInputFrames() {
  rectMode(CENTER);
  stroke(0, 32);
  fill(0, 16);
  //noStroke();
  //fill(0, 0, 200, 16);

  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i+0] & 0xff, 0, 256, 0, width);
    float y = map(INPUT_FRAMES[i+1] & 0xff, 0, 256, 0, height);
    float w = map(INPUT_FRAMES[i+2] & 0xff, 0, 256, width/20, width/4);
    float h = map(INPUT_FRAMES[i+3] & 0xff, 0, 256, height/20, height/4);
    rect(x, y, w, h);
  }
}

String hexString(byte[] b) {
  String s = "";
  for (int i = 0; i < b.length; i++) {
    s += String.format("%02x", b[i]);
  }
  return s;
}

void drawOutput(int bwidth) {
  Keccak mKeccak = new Keccak(576, 1024);

  stroke(200, 0, 0, 2);

  for (int i = 0; i < SIZE_INPUT_FRAMES / 64; i++) {
    byte[] iiin = Arrays.copyOfRange(INPUT_FRAMES, i * 64, (i + 1) * 64);
    byte[] iout = mKeccak.SHA3(iiin);

    for (int j = 0; j < min(iiin.length, iout.length); j++) {
      float iiinY = map(iiin[j], -128, 0x7f, bwidth, width - bwidth);
      float ioutY = map(iout[j], -128, 0x7f, bwidth, width - bwidth);
      for (int k = -6; k <= 6; k++) {
        line(k + iiinY, height - bwidth, k + ioutY, bwidth);
      }
    }
  }
}

void drawBorders(int bwidth) {
  rectMode(CORNER);
  stroke(255);
  fill(255);
  rect(0, 0, width, bwidth);
  rect(0, height-bwidth, width, bwidth);
  rect(0, 0, bwidth, height);
  rect(width-bwidth, 0, bwidth, height);

  noFill();
  stroke(10);
  rect(1, 1, width - 2, height - 2);
}
