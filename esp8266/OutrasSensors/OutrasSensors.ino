// https://circuits4you.com/2019/02/08/esp8266-nodemcu-https-secured-post-request/
// https://lastminuteengineers.com/multiple-ds18b20-arduino-tutorial/
// https://github.com/milesburton/Arduino-Temperature-Control-Library

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>

#include <OneWire.h>
#include <DallasTemperature.h>

#include "API_utils.h"

int const ONE_WIRE_BUS = D2;
int const NUM_SENSORS = 3;
int const TEMP_AVG_SIZE = 10;
int const TEMP_READ_DELAY = 1000;
int const TEMP_WRITE_DELAY = 30 * 1000;

String const API_SIGNAL_NAME[] = {
  "/TEMPERATURE_ARMPIT",
  "/TEMPERATURE_ANUSH",
  "/HEART_BEAT"
};

WiFiClientSecure httpsClient;

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

int rawReadingIndex = 0;
float rawReadings[NUM_SENSORS][TEMP_AVG_SIZE];
float avgSum[] = { 0, 0, 0 };
float avgs[NUM_SENSORS];

long lastReadMillis = 0;
long lastWriteMillis = 0;
float tempC = 0;

void setup(void) {
  ESP.wdtEnable(1000);
  Serial.begin(115200);
  sensors.begin();

  int sensor_count = sensors.getDeviceCount();
  if (sensor_count < NUM_SENSORS) {
    Serial.printf("\n\nThere are %d sensors; less than expected %d\n", sensor_count, NUM_SENSORS);
  } else {
    Serial.printf("\n\n%d temperature sensors\n", NUM_SENSORS);
  }

  Serial.printf("\n\nInitializing Sensors ... ");
  for (int v = 0; v < TEMP_AVG_SIZE; v++) {
    readTemperatures();
  }
  Serial.printf("\n\n");
  printAverages();

  connectToWiFi();

  httpsClient.setFingerprint(API_FINGERPRINT);
  httpsClient.setTimeout(10000);
}

void loop(void) {
  if (millis() > (lastReadMillis + TEMP_READ_DELAY)) {
    readTemperatures();
    printAverages();
    lastReadMillis = millis();
  }

  if (millis() > (lastWriteMillis + TEMP_WRITE_DELAY)) {
    for (int i = 0; i < NUM_SENSORS; i++) {
      float avg = avgSum[i] / TEMP_AVG_SIZE;
      avgs[i] = fmap(avg, 35, 41, 0.0, 1.0);
    }
    writeAllSignals(httpsClient, API_SIGNAL_NAME, avgs, 0, 3);
    lastWriteMillis = millis();
  }

  delay(1);
}

void readTemperatures() {
  ESP.wdtFeed();
  sensors.requestTemperatures();

  for (int i = 0; i < NUM_SENSORS; i++) {
    tempC = sensors.getTempCByIndex(i);
    avgSum[i] -= rawReadings[i][rawReadingIndex];
    rawReadings[i][rawReadingIndex] = tempC;
    avgSum[i] += rawReadings[i][rawReadingIndex];
  }

  rawReadingIndex = (rawReadingIndex + 1) % TEMP_AVG_SIZE;
}

void printAverages() {
  for (int i = 0; i < NUM_SENSORS; i++) {
    Serial.printf("[%d]: Temp(%.2f) | Avg(%.2f)\n",
                  i,
                  rawReadings[i][(rawReadingIndex + TEMP_AVG_SIZE - 1) % TEMP_AVG_SIZE],
                  avgSum[i] / TEMP_AVG_SIZE);
  }
  Serial.println();
}
