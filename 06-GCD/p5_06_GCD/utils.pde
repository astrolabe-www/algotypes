void drawInput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);

  byte in[] = loadBytes(sketchPath("../../Packets/in/" + INPUT_FILENAME));

  for (int i = 0; i < in.length; i += 4) {
    float x = map(in[i+0] & 0xff, 0, 256, 0, mpg.width);
    float y = map(in[i+1] & 0xff, 0, 256, 0, mpg.height);
    float w = map(in[i+2] & 0xff, 0, 256, mpg.width/20, mpg.width/4);
    float h = map(in[i+3] & 0xff, 0, 256, mpg.height/20, mpg.height/4);
    mpg.rect(x, y, w, h);
  }
  mpg.endDraw();
}

void drawOutput(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CORNER);
  mpg.stroke(200, 0, 0, 64);
  mpg.fill(200, 0, 0, 96);
  mpg.strokeWeight(OUT_SCALE * 1);

  int maxA = 0;
  int maxB = 0;
  int maxGCD = 0;

  for (int i = 0; i < INPUT.length - 1; i++) {
    int a = min(INPUT[i + 0], INPUT[i + 1]);
    int b = max(INPUT[i + 0], INPUT[i + 1]);
    int gcd = Euclid.gcd(a, b);

    if (gcd > maxGCD && a != b && a != gcd && b != gcd) {
      maxGCD = gcd;
      maxA = a;
      maxB = b;
    }
  }

  float sA = map(maxA, 0, 0xff, 0, 9.0/10.0 * mpg.width);
  float sB = maxB * sA / maxA;
  float sGCD = maxGCD * sA / maxA;
  float sX = (mpg.width - sA) / 2.0;
  float sY = (mpg.height - sB) / 2.0;

  mpg.rect(sX, sY, sA, sB);
  mpg.rect(sX, sY, sA, sA);
  mpg.rect(sX, sY, sGCD, sGCD);

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
