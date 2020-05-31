// references:
// https://witestlab.poly.edu/blog/802-11-wireless-lan-2/
// https://en.wikipedia.org/wiki/802.11_Frame_Types
// https://carvesystems.com/news/writing-a-simple-esp8266-based-sniffer/
// https://www.danielcasner.org/guidelines-for-writing-code-for-the-esp8266/

#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include "sdk_structs.h"
#include "ieee80211_structs.h"
#include "string_utils.h"

#include "API_utils.h"

extern "C" {
#include "user_interface.h"
}

const int NUM_CHANNELS = 13;
int rssiSum[NUM_CHANNELS];
int packetCount[NUM_CHANNELS];
uint16_t payloadSum[NUM_CHANNELS];

uint16_t payloadTotal = 0;

float avgs[NUM_CHANNELS];
String const API_SIGNAL_NAME[] = {
  "/WIFI_00",
  "/WIFI_01",
  "/WIFI_02",
  "/WIFI_03",
  "/WIFI_04",
  "/WIFI_05",
  "/WIFI_06",
  "/WIFI_07",
  "/WIFI_08",
  "/WIFI_09",
  "/WIFI_10",
  "/WIFI_11",
  "/WIFI_12"
};

uint8 cchannel = 0;
unsigned short CHANNEL_HOP_INTERVAL_MS = 4000;
static os_timer_t channelHop_timer;
bool isSniffing;
bool stopSniffing = false;

WiFiClientSecure httpsClient;

void wifi_sniffer_packet_handler(uint8_t *buff, uint16_t buff_length) {
  if (!isSniffing) return;

  // First layer: type cast the received buffer into our generic SDK structure
  const wifi_promiscuous_pkt_t *ppkt = (wifi_promiscuous_pkt_t *)buff;
  // Second layer: define pointer to where the actual 802.11 packet is within the structure
  const wifi_ieee80211_packet_t *ipkt = (wifi_ieee80211_packet_t *)ppkt->payload;
  // Third layer: define pointers to the 802.11 packet header
  const wifi_ieee80211_mac_hdr_t *hdr = &ipkt->hdr;

  // Pointer to the frame control section within the packet header
  const wifi_header_frame_control_t *frame_ctrl = (wifi_header_frame_control_t *)&hdr->frame_ctrl;

  // payload size and other infos
  const uint16_t payload_size = (uint16_t)(ppkt->rx_ctrl.sig_mode ? ppkt->rx_ctrl.HT_length : ppkt->rx_ctrl.legacy_length);
  const uint8_t mChannel = wifi_get_channel();
  const int16_t mRssi = ppkt->rx_ctrl.rssi;

  bool isCtrl = (buff_length == sizeof(wifi_pkt_rx_ctrl_t));
  if (isCtrl) return;

  rssiSum[mChannel] += mRssi;
  packetCount[mChannel] += 1;
  payloadSum[mChannel] += payload_size;
  payloadTotal += payload_size;

  if (packetCount[mChannel] < 5)
    Serial.printf("\n%2u | %03d | %4u | ", mChannel, mRssi, payload_size);
}

void channelHop() {
  if (!isSniffing) return;

  if (cchannel == 11) {
    isSniffing = false;
    stopSniffing = true;
    return;
  }

  cchannel = (cchannel + 1) % 12; // [0, 11]
  wifi_set_channel(cchannel + 1); // [1, 12]
}

void setup() {
  Serial.begin(115200);
  delay(10);

  httpsClient.setFingerprint(API_FINGERPRINT);
  httpsClient.setTimeout(10000);

  resetCounters();
  setupSniff();
}

void loop() {
  if (stopSniffing) {
    stopSniff();
    return;
  }

  if (isSniffing) {
    delay(10);
  } else {
    Serial.printf("\n\ntotal payload: %u\n", payloadTotal);

    uint16_t maxPayloadSum = 0;
    for (int c = 0; c < NUM_CHANNELS; c++) {
      if (payloadSum[c] > maxPayloadSum) maxPayloadSum = payloadSum[c];
    }

    for (int c = 0; c < NUM_CHANNELS; c++) {
      float avgRssi = float(rssiSum[c]) / max(1.0f, float(packetCount[c]));
      avgRssi = (avgRssi == 0.0) ? 0.0 : fmap(avgRssi, -100.0, -50.0, 0.0, 1.0);
      float avgPayload = float(payloadSum[c]) / max(1.0f, float(maxPayloadSum));

      avgs[c] = 0.1 * avgRssi + 0.9 * avgPayload;

      Serial.printf(" c(%d) packets: %u, payload: %u, rssi: %d ==> %f\n",
                    c, packetCount[c], payloadSum[c], rssiSum[c], avgs[c]);
    }

    writeAllSignals(httpsClient, API_SIGNAL_NAME, avgs, 1, 12);
    delay(100);

    resetCounters();
    setupSniff();
  }
}

void resetCounters() {
  for (int c = 0; c < NUM_CHANNELS; c++) {
    rssiSum[c] = 0;
    packetCount[c] = 0;
    payloadSum[c] = 0;
    avgs[c] = 0;
  }
  payloadTotal = 0;
}

void setupSniff() {
  cchannel = 0;

  wifi_station_disconnect();
  wifi_set_opmode(STATION_MODE);
  wifi_set_channel(cchannel + 1);
  wifi_promiscuous_enable(0);
  wifi_set_promiscuous_rx_cb(wifi_sniffer_packet_handler);
  wifi_promiscuous_enable(1);

  os_timer_disarm(&channelHop_timer);
  os_timer_setfn(&channelHop_timer, (os_timer_func_t *) channelHop, NULL);
  os_timer_arm(&channelHop_timer, CHANNEL_HOP_INTERVAL_MS, 1);

  isSniffing = true;
}

void stopSniff() {
  wifi_promiscuous_enable(0);
  os_timer_disarm(&channelHop_timer);
  wifi_station_disconnect();
  delay(100);

  connectToWiFi();

  isSniffing = false;
  stopSniffing = false;
}
