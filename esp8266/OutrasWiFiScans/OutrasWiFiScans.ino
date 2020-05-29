// https://arduino-esp8266.readthedocs.io/en/latest/esp8266wifi/scan-examples.html
// https://github.com/esp8266/Arduino/hardware/esp8266com/esp8266/libraries/ESP8266WiFi/src/ESP8266WiFi.h

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>

#include "API_utils.h"

/*

  RSSIMAX = -50
  RSSMIN = -100

  => dbt2percent = 2*(db+100)

*/

const int NUM_CHANNELS = 13;
int channelCount[NUM_CHANNELS];
int channelSum[NUM_CHANNELS];

int const SCAN_DELAY = 30000;
long lastScanMillis = 0;

char API_SIGNAL_NAME[] = "/WIFI_00";

WiFiClientSecure httpsClient;

void setup() {
  Serial.begin(115200);

  disconnectFromWiFi();

  httpsClient.setFingerprint(API_FINGERPRINT);
  httpsClient.setTimeout(10000);
}

void loop() {
  if (millis() > (lastScanMillis + SCAN_DELAY)) {
    scanRssi();
    printCounters();
    connectToWiFi();

    for (int c = 1; c < NUM_CHANNELS; c++) {
      sprintf(API_SIGNAL_NAME, "/WIFI_%02d", c);

      float avg = float(channelSum[c]) / max(1.0f, float(channelCount[c]));
      // TODO: map the average to [0,1]
      float val = random(100) / 100.0;
      writeSignal(httpsClient, String(API_SIGNAL_NAME), val);
    }
    lastScanMillis = millis();
  }
}

void scanRssi() {
  WiFi.mode(WIFI_OFF);
  delay(100);
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(100);
  clearCounters();
  Serial.print("Scanning ... ");
  int n = WiFi.scanNetworks();
  Serial.printf("%d network(s) found\n", n);
  for (int i = 0; i < n; i++) {
    int mCHNL =  WiFi.channel(i);
    int mRSSI = WiFi.RSSI(i);
    channelCount[mCHNL] += 1;
    channelSum[mCHNL] += mRSSI;
  }
  WiFi.scanDelete();
}

void clearCounters() {
  for (int c = 0; c < NUM_CHANNELS; c++) {
    channelCount[c] = 0;
    channelSum[c] = 0;
  }
}

void printCounters() {
  for (int c = 0; c < NUM_CHANNELS; c++) {
    Serial.printf("ch: %d , sum: %d , cnt: %d, avg: %.2f\n",
                  c,
                  channelSum[c],
                  channelCount[c],
                  float(channelSum[c]) / max(1.0f, float(channelCount[c])));
  }
  Serial.println();
}