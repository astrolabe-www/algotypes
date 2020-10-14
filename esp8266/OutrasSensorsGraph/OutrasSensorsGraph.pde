
JSONObject json;

void setup() {
  json = loadJSONObject(dataPath("in/outras.json"));

  JSONArray signals = json.getJSONObject("data").getJSONArray("signals");

  for (int i = 0; i < signals.size(); i++) {
    JSONObject mSignal = signals.getJSONObject(i);
    String mName = mSignal.getString("name");
    JSONArray mValues = mSignal.getJSONArray("values");

    drawGraph(mValues, mName);
  }
}

void draw() {
  exit();
}

void drawGraph(JSONArray mValues, String mName) {
  int mValuesCount = mValues.size();
  PGraphics mPG = createGraphics(1280, 720);
  println(mName);

  mPG.beginDraw();
  mPG.background(255);
  mPG.stroke(4);
  mPG.fill(4);
  mPG.textAlign(CENTER);
  mPG.textSize(32);
  mPG.text(mName, 0, 0, mPG.width, 80);

  int AVERAGE_SIZE = 128;
  float[] avgVals = new float[AVERAGE_SIZE];
  float avgSum = 0;
  int currAvgIndex = 0;
  float lastAvg = 0;

  for (int v = 0; v < AVERAGE_SIZE; v++) {
    avgVals[v] = mValues.getFloat(v);
    avgSum += avgVals[v];
  }
  lastAvg = avgSum / AVERAGE_SIZE;

  for (int v = 1; v < mValuesCount; v++) {
    avgSum -= avgVals[currAvgIndex];
    avgVals[currAvgIndex] = mValues.getFloat(v);
    avgSum += avgVals[currAvgIndex];
    currAvgIndex = (currAvgIndex + 1) % AVERAGE_SIZE;

    float x0 = float(v-1) / mValuesCount * mPG.width;
    float x1 = float(v) / mValuesCount * mPG.width;
    float y0 = mPG.height -  lastAvg * mPG.height;
    float y1 = mPG.height -  avgSum / AVERAGE_SIZE * mPG.height;
    mPG.line(x0, y0, x1, y1);

    lastAvg = avgSum / AVERAGE_SIZE;
  }
  mPG.endDraw();
  mPG.save(dataPath("out/" + mName + ".jpg"));
}
