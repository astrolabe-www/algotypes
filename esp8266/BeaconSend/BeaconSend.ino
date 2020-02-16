#include <ESP8266WiFi.h>
#include "BeaconPacket.h"

extern "C" {
#include "user_interface.h"
  typedef void (*freedom_outside_cb_t)(uint8 status);
  int wifi_register_send_pkt_freedom_cb(freedom_outside_cb_t cb);
  void wifi_unregister_send_pkt_freedom_cb(void);
  int wifi_send_pkt_freedom(uint8 *buf, int len, bool sys_seq);
}

const uint8_t CHANNELS[] = {1, 5, 6, 7};
const uint8_t NUM_CHANNELS = sizeof(CHANNELS) / sizeof(uint8_t);

const char *SSIDS[] = {
  "00-PRNG",
  "01-FFT",
  "02-Eigenvs",
  "08-TSP",
  "09-SHA3",
  "10-Perlin",
  "11-Trees",
  "12-Inversion",
  "15-JPEG",
  "16-PoW",
  "19-Prime",
  "21-PID"
};

const uint8_t NUM_SSIDS = sizeof(SSIDS) / sizeof(char*);

const uint32_t PACKET_SIZE = sizeof(beaconPacket);

uint32_t TX_PERIOD_MS = 100;

char emptySSID[32];
uint8_t channelIndex = 0;
uint8_t currentChannel = 1;
uint8_t macAddr[6];
uint32_t lastTxTime = 0;

void updateChannel() {
  uint8_t ch = CHANNELS[channelIndex];
  channelIndex = (channelIndex + 1) % NUM_CHANNELS;

  if (ch != currentChannel && ch >= 1 && ch <= 14) {
    currentChannel = ch;
    wifi_set_channel(currentChannel);
  }
}

void setup() {
  for (int i = 0; i < 32; i++)
    emptySSID[i] = ' ';
  for (int i = 0; i < 6; i++)
    macAddr[i] = random(256);

  WiFi.mode(WIFI_OFF);
  wifi_set_opmode(STATION_MODE);
  wifi_set_channel(CHANNELS[0]);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  if (millis() - lastTxTime > TX_PERIOD_MS) {
    lastTxTime = millis();

    updateChannel();

    for (uint8_t ssidIndex = 0; ssidIndex < NUM_SSIDS; ssidIndex++) {
      String mSSID = SSIDS[ssidIndex];

      macAddr[5] = ssidIndex;

      // write MAC address into beacon frame
      memcpy(&beaconPacket[10], macAddr, 6);
      memcpy(&beaconPacket[16], macAddr, 6);

      // reset and set SSID
      memcpy(&beaconPacket[38], emptySSID, 32);
      memcpy(&beaconPacket[38], mSSID.c_str(), mSSID.length());

      // set channel for beacon frame
      beaconPacket[82] = currentChannel;

      for (int k = 0; k < 3; k++) {
        wifi_send_pkt_freedom(beaconPacket, PACKET_SIZE, 0);
        delay(1);
      }
    }
  }

  if ((millis() / 50) % 20 == 0) {
    digitalWrite(LED_BUILTIN, LOW);
    delay(10);
    digitalWrite(LED_BUILTIN, HIGH);
  }
}
