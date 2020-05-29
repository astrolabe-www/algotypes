// https://lastminuteengineers.com/multiple-ds18b20-arduino-tutorial/
// https://github.com/milesburton/Arduino-Temperature-Control-Library

#include <OneWire.h>
#include <DallasTemperature.h>

int const ONE_WIRE_BUS = D2;
int TEMP_SENSOR_COUNT = 0;
int const TEMP_AVG_SIZE = 10;
int const TEMP_READ_DELAY = 1000;

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

int avgIndex = 0;
float avgSum[] = { 0, 0, 0 };
float avgValues[3][TEMP_AVG_SIZE];

long lastReadMillis = 0;
float tempC = 0;

void setup(void) {
  ESP.wdtEnable(1000);
  Serial.begin(115200);
  sensors.begin();

  TEMP_SENSOR_COUNT = sensors.getDeviceCount();
  Serial.printf("\n\n%d temperature sensors\n", TEMP_SENSOR_COUNT);

  Serial.printf("Initializing ... ");
  for (int v = 0; v < TEMP_AVG_SIZE; v++) {
    if (v % 10 == 0) Serial.printf("%d ", v);
    readTemperatures();
  }
  Serial.printf("\n\n");
  printAverages();
}

void loop(void) {
  if (millis() > (lastReadMillis + TEMP_READ_DELAY)) {
    readTemperatures();
    printAverages();
    lastReadMillis = millis();
  }

  delay(1);
}

void readTemperatures() {
  ESP.wdtFeed();
  sensors.requestTemperatures();

  for (int i = 0; i < TEMP_SENSOR_COUNT; i++) {
    tempC = sensors.getTempCByIndex(i);
    avgSum[i] -= avgValues[i][avgIndex];
    avgValues[i][avgIndex] = tempC;
    avgSum[i] += avgValues[i][avgIndex];
  }

  avgIndex = (avgIndex + 1) % TEMP_AVG_SIZE;
}

void printAverages() {
  for (int i = 0; i < TEMP_SENSOR_COUNT; i++) {
    Serial.printf("[%d]: Temp(%.2f) | Avg(%.2f)\n",
                  i,
                  avgValues[i][(avgIndex + TEMP_AVG_SIZE - 1) % TEMP_AVG_SIZE],
                  avgSum[i] / TEMP_AVG_SIZE);
  }
  Serial.println();
}
