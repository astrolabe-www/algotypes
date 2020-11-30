import java.util.Arrays;

void drawOutput(PGraphics mpg) {
  Keccak mKeccak = new Keccak(576, 1024);

  mpg.beginDraw();
  mpg.strokeWeight(OUT_SCALE);
  mpg.stroke(200, 0, 0, 8);
  mpg.noFill();

  for (int i = 0; i < INPUT_BYTES.length / 64; i++) {
    byte[] iin = Arrays.copyOfRange(INPUT_BYTES, i * 64, (i + 1) * 64);
    byte[] out = mKeccak.SHA3(iin);

    for (int j = 0; j < min(iin.length, out.length); j+=2) {
      float iinX = map(iin[j], -128, 127, BORDER_WIDTH, mpg.width - BORDER_WIDTH);
      float outX = map(out[j], -128, 127, BORDER_WIDTH, mpg.width - BORDER_WIDTH);
      float outX2x = map(out[j], -128, 127, -mpg.width, 2 * mpg.width);

      mpg.beginShape();
      mpg.vertex(iinX, mpg.height - BORDER_WIDTH);
      mpg.vertex(outX, BORDER_WIDTH);
      mpg.vertex(outX2x, BORDER_WIDTH);
      mpg.vertex(iinX, mpg.height - BORDER_WIDTH);
      mpg.endShape();
    }
  }
  mpg.endDraw();
}

String hexString(byte[] b) {
  String s = "";
  for (int i = 0; i < b.length; i++) {
    s += String.format("%02x", b[i]);
  }
  return s;
}
