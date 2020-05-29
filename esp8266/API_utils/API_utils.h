#ifndef _API_UTILS_
#define _API_UTILS_

#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>

#include "parameters.h"

void connectToWiFi() {
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
}

void disconnectFromWiFi() {
  WiFi.mode(WIFI_OFF);
  delay(100);
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(100);
}

String httpsClientResponseLine;
void writeSignal(WiFiClientSecure& httpsClient, String API_SIGNAL_NAME, float signalValue) {
  String API_SIGNAL_VALUE = '/' + String(signalValue, 2);
  String postURL = API_ENDPOINT + API_SIGNAL_NAME + API_SIGNAL_VALUE;
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

#endif