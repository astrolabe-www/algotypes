import java.util.Arrays;

void drawInput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);
  for (int i = 0; i < INPUT.length; i += 4) {
    float x = map(INPUT[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(INPUT[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(INPUT[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(INPUT[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg, int bwidth) {
  Keccak mKeccak = new Keccak(576, 1024);

  mpg.beginDraw();
  mpg.strokeWeight(OUT_SCALE / 2);
  mpg.stroke(200, 0, 0, 8);
  mpg.noFill();

  for (int i = 0; i < INPUT.length / 64; i++) {
    byte[] iin = Arrays.copyOfRange(INPUT, i * 64, (i + 1) * 64);
    byte[] out = mKeccak.SHA3(iin);

    for (int j = 0; j < min(iin.length, out.length); j+=2) {
      float iinX = map(iin[j], -128, 127, bwidth, mpg.width - bwidth);
      float outX = map(out[j], -128, 127, bwidth, mpg.width - bwidth);
      float outX2x = map(out[j], -128, 127, -mpg.width, 2 * mpg.width);

      mpg.beginShape();
      mpg.vertex(iinX, mpg.height - bwidth);
      mpg.vertex(outX, bwidth);
      mpg.vertex(outX2x, bwidth);
      mpg.vertex(iinX, mpg.height - bwidth);
      mpg.endShape();
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

  mpg.noStroke();
  mpg.textFont(mFont);
  mpg.textSize(OUT_SCALE * FONT_SIZE);
  mpg.rectMode(CENTER);
  mpg.textAlign(CENTER, CENTER);
  mpg.fill(255);
  mpg.rect(mpg.width/2, bwidth, 1.111 * mpg.textWidth(Card.number), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.number, mpg.width/2, OUT_SCALE * FONT_SIZE / 2);

  mpg.fill(255);
  mpg.rect(mpg.width/2, mpg.height - bwidth, 1.111 * mpg.textWidth(Card.name), 2 * OUT_SCALE * FONT_SIZE);
  mpg.fill(0);
  mpg.text(Card.name, mpg.width/2, mpg.height - OUT_SCALE * 32);

  mpg.rectMode(CORNER);
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
