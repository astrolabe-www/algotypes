import java.util.Arrays;

void drawInputFrames() {
  rectMode(CENTER);
  stroke(0, 32);
  fill(0, 0, 200, 16);
  fill(0, 16);
  for (int i = 0; i < SIZE_INPUT_FRAMES; i += 4) {
    float x = map(INPUT_FRAMES[i], 0, 256, 0, width);
    float y = map(INPUT_FRAMES[i+1], 0, 256, 0, height);
    float w = map(INPUT_FRAMES[i+2], 0, 256, width/20, width/4);
    float h = map(INPUT_FRAMES[i+3], 0, 256, height/20, height/4);
    rect(x, y, w, h);
  }
}

void drawOutput(int bwidth) {
  float y = bwidth;
  int mHeight = height - 2 * bwidth;

  stroke(255, 0, 0, 64);
  fill(255, 0, 0, 16);
  noiseSeed(101010);

  float[] out = A.page_rank().value;
  Arrays.sort(out);

  for (int i = out.length - 1; i > -1; i--) {
    //float h = 32.0 * out[out.length - 1 - i] * mHeight;
    //ellipseMode(CENTER);
    //noStroke();
    //ellipse(width / 2.0, y + h / 2.0, h, h);
    //y += mHeight * out[i];

    float h = 32.0 * out[i] * mHeight;
    ellipseMode(CORNER);
    ellipse(width / 2.0 - h / 2.0, height / 4.0 - i, h, h);
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
  rect(1, 1, width-3, height-3);
}
