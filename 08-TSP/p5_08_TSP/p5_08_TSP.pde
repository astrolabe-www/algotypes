// Based on:
// https://en.wikipedia.org/wiki/Nearest_neighbour_algorithm
// https://en.wikipedia.org/wiki/Travelling_salesman_problem#Heuristic_and_approximation_algorithms
// https://en.wikipedia.org/wiki/Simulated_annealing

// input
int SIZE_INPUT_NOISE = 1024;
int[] INPUT_NOISE = new int[SIZE_INPUT_NOISE];

String INPUT_FRAMES_FILENAME = "frames_20200207-0004_reqs.raw";
int SIZE_INPUT_FRAMES;
int[] INPUT_FRAMES;

void initInputNoise() {
  for (int i = 0; i < SIZE_INPUT_NOISE; i++) {
    INPUT_NOISE[i] = int(0xff * noise(i, frameCount));
  }
}

void initInputFrames() {
  byte in[] = loadBytes(sketchPath("../../esp8266/" + INPUT_FRAMES_FILENAME));

  SIZE_INPUT_FRAMES = in.length;
  INPUT_FRAMES = new int[SIZE_INPUT_FRAMES];

  for (int i = 0; i < SIZE_INPUT_FRAMES; i++) {
    INPUT_FRAMES[i] = (in[i] & 0xff) + 1;
  }
}

Greedy mGreedy;
Annealing mAnnealing;
int border_width = 10;

void setup() {
  size(469, 804);
  noLoop();
  initInputNoise();
  initInputFrames();
}

void draw() {
  mGreedy = new Greedy(INPUT_FRAMES);
  mAnnealing = new Annealing(INPUT_FRAMES);

  background(255);

  drawInputFrames();
  drawOutput(border_width);
  drawBorders(border_width);
}
