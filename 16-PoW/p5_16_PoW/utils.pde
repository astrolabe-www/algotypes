import java.util.Arrays;

void drawInputFrames(PGraphics mpg) {
  mpg.beginDraw();

  mpg.rectMode(CENTER);
  mpg.stroke(0, 32);
  mpg.fill(0, 0, 200, 16);
  mpg.fill(0, 16);

  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME[2]));

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
  int maxNonce = 0;
  int minNonce = 0x7fffffff;
  int[] nonces = new int[INPUT_FRAMES.length];
  Block[] chain = new Block[INPUT_FRAMES.length];

  chain[0] = new Block(INPUT_FRAMES[0]);
  for (int i = 1; i < chain.length; i++) {
    if (chain[i-1].nonce() > maxNonce) maxNonce = chain[i-1].nonce();
    if (chain[i-1].nonce() < minNonce) minNonce = chain[i-1].nonce();

    chain[i] = new Block(INPUT_FRAMES[i % INPUT_FRAMES.length], chain[i-1].hash(), chain[i-1].nextTarget());
    nonces[i - 1] = chain[i - 1].nonce();
  }
  nonces[chain.length - 1] = chain[chain.length - 1].nonce();
  Arrays.sort(nonces);

  mpg.beginDraw();
  mpg.fill(200, 0, 0, 16);
  mpg.stroke(200, 0, 0, 64);
  mpg.strokeWeight(1.2 * OUT_SCALE);

  for (int i = nonces.length - 1; i >= 0; i--) {
    float noiseScale = map(max(nonces[i], 10e3), 0, maxNonce, 1024, 32);
    float yScale = map(max(nonces[i], 10e3), minNonce, maxNonce, 1.0, 2.0);
    float yc = mpg.height / 2;

    mpg.beginShape();
    mpg.vertex(0, yc);
    for (int x = 1; x < mpg.width; x++) {
      float y = yc + (2 * yScale * noise(x/noiseScale, yc/noiseScale) - yScale) * mpg.height / chain.length;
      mpg.vertex(x, y);
    }
    mpg.vertex(mpg.width, yc);
    mpg.endShape();
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
