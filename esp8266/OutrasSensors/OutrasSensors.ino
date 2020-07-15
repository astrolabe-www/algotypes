// https://circuits4you.com/2019/02/08/esp8266-nodemcu-https-secured-post-request/
// https://lastminuteengineers.com/multiple-ds18b20-arduino-tutorial/
// https://github.com/milesburton/Arduino-Temperature-Control-Library

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>

#include <OneWire.h>
#include <DallasTemperature.h>

#define USE_ARDUINO_INTERRUPTS false
#include <PulseSensorPlayground.h>

#include "API_utils.h"

int const ONE_WIRE_BUS = D2;
int const TEMP_SENSOR_COUNT = 2;
int const TEMP_AVG_SIZE = 10;
int const TEMP_READ_DELAY = 1000;
int const TEMP_WRITE_DELAY = 30 * 1000;

const int HEART_BEAT_INPUT = A0;
const int HEART_BEAT_THRESHOLD = 550;

String const API_SIGNAL_NAME[] = {
  "/TEMPERATURE_ARMPIT",
  "/TEMPERATURE_MOUTH",
  "/HEART_BEAT"
};

WiFiClientSecure httpsClient;

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature tempSensors(&oneWire);
PulseSensorPlayground pulseSensor;

int tempRawReadingIndex = 0;
int beatRawReadingIndex = 0;
float rawReadings[TEMP_SENSOR_COUNT + 1][TEMP_AVG_SIZE];
float avgSum[] = { 0, 0, 0 };
float avgs[TEMP_SENSOR_COUNT + 1];

long lastReadMillis = 0;
long lastWriteMillis = 0;
float tempC = 0;
int mBPM = 0;

void setup(void) {
  ESP.wdtEnable(1000);
  Serial.begin(115200);
  tempSensors.begin();

  int sensor_count = tempSensors.getDeviceCount();
  if (sensor_count < TEMP_SENSOR_COUNT) {
    Serial.printf("\n\nThere are %d tempSensors; less than expected %d\n", sensor_count, TEMP_SENSOR_COUNT);
  } else {
    Serial.printf("\n\n%d temperature sensors\n", TEMP_SENSOR_COUNT);
  }

  Serial.printf("\n\nInitializing Sensors ... ");
  for (int v = 0; v < TEMP_AVG_SIZE; v++) {
    readTemperatures();
  }
  Serial.printf("\n\n");
  printAverages();

  pulseSensor.analogInput(HEART_BEAT_INPUT);
  pulseSensor.setThreshold(HEART_BEAT_THRESHOLD);

  if (!pulseSensor.begin()) {
    Serial.printf("\nHEART BEAT SENSOR FAIL\n");
  }

  connectToWiFi();

  httpsClient.setFingerprint(API_FINGERPRINT);
  httpsClient.setTimeout(10000);
}

void loop(void) {
  readHeartBeat();

  if (millis() > (lastReadMillis + TEMP_READ_DELAY)) {
    readTemperatures();
    printAverages();
    lastReadMillis = millis();
  }

  if (millis() > (lastWriteMillis + TEMP_WRITE_DELAY)) {
    for (int i = 0; i < TEMP_SENSOR_COUNT; i++) {
      float avg = avgSum[i] / TEMP_AVG_SIZE;
      avgs[i] = fmap(avg, 25, 41, 0.0, 1.0);
    }
    float avg = avgSum[TEMP_SENSOR_COUNT] / TEMP_AVG_SIZE;
    avgs[TEMP_SENSOR_COUNT] = fmap(avg, 50, 120, 0.0, 1.0);

    writeAllSignals(httpsClient, API_SIGNAL_NAME, avgs, 0, 3);
    lastWriteMillis = millis();
  }
}

void readTemperatures() {
  ESP.wdtFeed();
  tempSensors.requestTemperatures();

  for (int i = 0; i < TEMP_SENSOR_COUNT; i++) {
    tempC = tempSensors.getTempCByIndex(i);
    avgSum[i] -= rawReadings[i][tempRawReadingIndex];
    rawReadings[i][tempRawReadingIndex] = tempC;
    avgSum[i] += rawReadings[i][tempRawReadingIndex];
  }

  tempRawReadingIndex = (tempRawReadingIndex + 1) % TEMP_AVG_SIZE;
}

void readHeartBeat() {
  if (pulseSensor.sawNewSample()) {
    mBPM = pulseSensor.getBeatsPerMinute();
    if (mBPM > 1) {
      avgSum[TEMP_SENSOR_COUNT] -= rawReadings[TEMP_SENSOR_COUNT][beatRawReadingIndex];
      rawReadings[TEMP_SENSOR_COUNT][beatRawReadingIndex] = mBPM;
      avgSum[TEMP_SENSOR_COUNT] += rawReadings[TEMP_SENSOR_COUNT][beatRawReadingIndex];
      beatRawReadingIndex = (beatRawReadingIndex + 1) % TEMP_AVG_SIZE;
    }
  }
}

void printAverages() {
  for (int i = 0; i < TEMP_SENSOR_COUNT; i++) {
    Serial.printf("[%d]: Temp(%.2f) | Avg(%.2f)\n",
                  i,
                  rawReadings[i][(tempRawReadingIndex + TEMP_AVG_SIZE - 1) % TEMP_AVG_SIZE],
                  avgSum[i] / TEMP_AVG_SIZE);
  }
  Serial.printf("[H]: bpm(%i) | Avg(%.2f)\n", mBPM, avgSum[TEMP_SENSOR_COUNT] / TEMP_AVG_SIZE);
  Serial.println();
}
