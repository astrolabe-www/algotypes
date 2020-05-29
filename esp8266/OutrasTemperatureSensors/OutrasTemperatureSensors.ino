// https://circuits4you.com/2019/02/08/esp8266-nodemcu-https-secured-post-request/
// https://lastminuteengineers.com/multiple-ds18b20-arduino-tutorial/
// https://github.com/milesburton/Arduino-Temperature-Control-Library

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>

#include <OneWire.h>
#include <DallasTemperature.h>

#include "parameters.h"

int const ONE_WIRE_BUS = D2;
int TEMP_SENSOR_COUNT = 0;
int const TEMP_AVG_SIZE = 10;
int const TEMP_READ_DELAY = 1000;
int const TEMP_WRITE_DELAY = 30 * 1000;
String const API_ENDPOINT = "/signals";

String const API_SIGNAL_NAME[] = {
  "/TEMPERATURE_ARMPIT",
  "/TEMPERATURE_ANUSH",
  "/HEART_BEAT"
};

WiFiClientSecure httpsClient;
String httpsClientResponseLine;

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

int avgIndex = 0;
float avgSum[] = { 0, 0, 0 };
float avgValues[3][TEMP_AVG_SIZE];

long lastReadMillis = 0;
long lastWriteMillis = 0;
float tempC = 0;

void setup(void) {
  ESP.wdtEnable(1000);
  Serial.begin(115200);
  sensors.begin();

  TEMP_SENSOR_COUNT = sensors.getDeviceCount();
  Serial.printf("\n\n%d temperature sensors\n", TEMP_SENSOR_COUNT);

  Serial.printf("\n\nInitializing Sensors ... ");
  for (int v = 0; v < TEMP_AVG_SIZE; v++) {
    readTemperatures();
  }
  Serial.printf("\n\n");
  printAverages();

  Serial.printf("\n\nConnecting to WiFi ...");
  WiFi.mode(WIFI_OFF);
  delay(100);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID.c_str(), WIFI_PASS.c_str());

  for (int counter = 0; (WiFi.status() != WL_CONNECTED) && (counter < 32); counter++) {
    delay(100);
    Serial.print(".");
  }
  Serial.println(".");

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
    for (int i = 0; i < TEMP_SENSOR_COUNT; i++) {
      // TODO: map the average to [0,1]
      // float val = avgSum[i] / TEMP_AVG_SIZE;
      float val = random(100) / 100.0;
      writeSignal(i, val);
    }

    lastWriteMillis = millis();
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

void writeSignal(int signalIndex, float signalValue) {
  String API_SIGNAL_VALUE = '/' + String(signalValue, 2);
  String postURL = API_ENDPOINT + API_SIGNAL_NAME[signalIndex] + API_SIGNAL_VALUE;
  Serial.printf("%s%s\n", API_URL.c_str(), postURL.c_str());

  Serial.printf("\n\nConnecting to API...");
  for (int counter = 0; (!httpsClient.connect(API_URL, API_PORT)) && (counter < 32); counter++) {
    delay(100);
    Serial.print(".");
  }
  Serial.println(".");

  httpsClient.print(String("POST ") + postURL + " HTTP/1.1\r\n" +
                    "Host: " + API_URL + "\r\n" +
                    "Content-Type: application/x-www-form-urlencoded" + "\r\n" +
                    "Content-Length: 3" + "\r\n\r\n" +
                    "a=b" + "\r\n" +
                    "Connection: close\r\n\r\n");

  while (httpsClient.connected() || httpsClient.available()) {
    httpsClientResponseLine = httpsClient.readStringUntil('\n');
  }
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
