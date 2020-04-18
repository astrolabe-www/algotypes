import java.util.Arrays;

void drawOutput(PGraphics mpg) {
  int maxNonce = 0;
  int minNonce = 0x7fffffff;
  int[] nonces = new int[chain.length];

  for (int i = 0; i < chain.length; i++) {
    if (chain[i].nonce() > maxNonce) maxNonce = chain[i].nonce();
    if (chain[i].nonce() < minNonce) minNonce = chain[i].nonce();
    nonces[i] = chain[i].nonce();
  }
  Arrays.sort(nonces);

  noiseSeed(101010);

  mpg.beginDraw();
  mpg.fill(200, 0, 0, 16);
  //mpg.noFill();
  mpg.stroke(200, 0, 0, 132);
  mpg.strokeWeight(1.2 * OUT_SCALE);

  for (int i = nonces.length - 1; i >= 0; i--) {
    float noiseScale = map(max(nonces[i], 10e3), 0, maxNonce, 2048, 256) * OUT_SCALE / 10.0;
    float yScale = map(max(nonces[i], 10e3), minNonce, maxNonce, 2.0, 3.0);
    float yc = mpg.height / 2;
    //float yScale = map(max(nonces[i], 10e3), minNonce, maxNonce, 1.0, 0.8);
    //float yc = (i + 0.5) * mpg.height / nonces.length;

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
