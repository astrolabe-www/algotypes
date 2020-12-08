// references:
// https://witestlab.poly.edu/blog/802-11-wireless-lan-2/
// https://en.wikipedia.org/wiki/802.11_Frame_Types
// https://carvesystems.com/news/writing-a-simple-esp8266-based-sniffer/
// https://www.danielcasner.org/guidelines-for-writing-code-for-the-esp8266/

#include <Arduino.h>
#include <ESP8266WiFi.h>
#include "Board.cpp"
#include "BeaconPacket.h"
#include "sdk_structs.h"
#include "ieee80211_structs.h"
#include "string_utils.h"

extern "C" {
#include "user_interface.h"
  typedef void (*freedom_outside_cb_t)(uint8 status);
  int wifi_register_send_pkt_freedom_cb(freedom_outside_cb_t cb);
  void wifi_unregister_send_pkt_freedom_cb(void);
  int wifi_send_pkt_freedom(uint8 *buf, int len, bool sys_seq);
}

const uint8_t mCHANNEL = 4;
const uint8_t mMAC = 0x54;
const String mSSID = "0x04-Alpha-Beta";

const uint32_t BEACON_PACKET_SIZE = sizeof(beaconPacket);
const uint8_t BEACON_PACKET_INDEX_CHANNEL = 82;
const uint8_t BEACON_PACKET_INDEX_SOURCE = 15;
const uint8_t BEACON_PACKET_INDEX_SSID = 38;
const uint8_t BEACON_PACKET_INDEX_DATA = BEACON_PACKET_INDEX_CHANNEL + 1;
const uint32_t BEACON_PACKET_DATA_SIZE = min(100u, BEACON_PACKET_SIZE - BEACON_PACKET_INDEX_DATA);

uint32_t TX_PERIOD_MS = 100;
uint32_t lastTxTime = 0;

uint32_t COMPUTE_PERIOD_MS = 30000;
uint32_t lastComputeTime = 0;

const int DATA_IN_SIZE = 2048;
int DATA_IN[DATA_IN_SIZE];
int DATA_IN_CNT = 0;

const int DATA_OUT_SIZE = 2048;
uint8_t DATA_OUT[DATA_OUT_SIZE];

void wifi_sniffer_packet_handler(uint8_t *buff, uint16_t buff_length) {
  // First layer: type cast the received buffer into our generic SDK structure
  const wifi_promiscuous_pkt_t *ppkt = (wifi_promiscuous_pkt_t *)buff;
  // Second layer: define pointer to where the actual 802.11 packet is within the structure
  const wifi_ieee80211_packet_t *ipkt = (wifi_ieee80211_packet_t *)ppkt->payload;
  // Third layer: define pointers to the 802.11 packet header
  const wifi_ieee80211_mac_hdr_t *hdr = &ipkt->hdr;

  // Pointer to the frame control section within the packet header
  const wifi_header_frame_control_t *frame_ctrl = (wifi_header_frame_control_t *)&hdr->frame_ctrl;

  // payload size
  const uint16_t payload_size = (uint16_t)(ppkt->rx_ctrl.sig_mode ? ppkt->rx_ctrl.HT_length : ppkt->rx_ctrl.legacy_length);

  bool isBeacon = (frame_ctrl->type == WIFI_PKT_MGMT && frame_ctrl->subtype == BEACON);
  bool isProbeR = (frame_ctrl->type == WIFI_PKT_MGMT && frame_ctrl->subtype == PROBE_REQ);
  bool isData = (frame_ctrl->type == WIFI_PKT_DATA);
  bool isCtrl = (buff_length == sizeof(wifi_pkt_rx_ctrl_t));

  if (isCtrl) return;
  if (isData) return;
  //if (!isBeacon) return;
  //if (!isProbeR) return;
  //if (!(isData || isProbeR)) return;
  //if (!(isBeacon || isData || isProbeR)) return;

  // Parse MAC addresses contained in packet header into human-readable strings
  char addr1[] = "00:00:00:00:00:00\0";
  char addr2[] = "00:00:00:00:00:00\0";
  char addr3[] = "00:00:00:00:00:00\0";

  mac2str(hdr->addr1, addr1);
  mac2str(hdr->addr2, addr2);
  mac2str(hdr->addr3, addr3);

  // Output info to serial
  Serial.printf("\n%s | %s | %s | %2u | %03d | %3u | %4u | %-18s | ",
                addr1,
                addr2,
                addr3,
                wifi_get_channel(),
                ppkt->rx_ctrl.rssi,
                buff_length,
                payload_size,
                wifi_pkt_type2str((wifi_promiscuous_pkt_type_t)frame_ctrl->type, (wifi_mgmt_subtypes_t)frame_ctrl->subtype)
               );

  // Print ESSID if beacon
  if (frame_ctrl->type == WIFI_PKT_MGMT && frame_ctrl->subtype == BEACON) {
    const wifi_mgmt_beacon_t *beacon_frame = (wifi_mgmt_beacon_t*) ipkt->payload;
    char ssid[32] = {0};

    if (beacon_frame->tag_length >= 32) {
      strncpy(ssid, beacon_frame->ssid, 31);
    } else {
      strncpy(ssid, beacon_frame->ssid, beacon_frame->tag_length);
    }
    Serial.printf("%s", ssid);
  }

  // Print ESSID if probe request
  if (frame_ctrl->type == WIFI_PKT_MGMT && frame_ctrl->subtype == PROBE_REQ) {
    const wifi_mgmt_probe_req_t *probe_req_frame = (wifi_mgmt_probe_req_t*) ipkt->payload;
    char ssid[32] = {0};

    if (probe_req_frame->tag_length >= 32) {
      strncpy(ssid, probe_req_frame->ssid, 31);
    } else {
      strncpy(ssid, probe_req_frame->ssid, probe_req_frame->tag_length);
    }
    Serial.printf("%s", ssid);
  }

  // copy payload to DATA
  uint8_t* pload = ((wifi_promiscuous_pkt_t *)buff)->payload;
  int bytes_to_copy = min((int)(payload_size), DATA_IN_SIZE - DATA_IN_CNT);

  for (int i = 0; i < bytes_to_copy; i++) {
    DATA_IN[DATA_IN_CNT] = (int)(pload[i]) & 0xFF;
    DATA_IN_CNT++;
  }
}

void setup() {
  Serial.begin(115200);
  delay(10);

  // Wifi setup
  wifi_set_opmode(STATION_MODE);
  wifi_set_channel(mCHANNEL);

  wifi_promiscuous_enable(0);
  wifi_set_promiscuous_rx_cb(wifi_sniffer_packet_handler);
  wifi_promiscuous_enable(1);

  // set SSID and channel in beacon packet
  memcpy(&beaconPacket[BEACON_PACKET_INDEX_SSID], mSSID.c_str(), mSSID.length());
  beaconPacket[BEACON_PACKET_INDEX_CHANNEL] = mCHANNEL;
  beaconPacket[BEACON_PACKET_INDEX_SOURCE + 0] = mMAC;
  beaconPacket[BEACON_PACKET_INDEX_SOURCE + 6] = mMAC;

  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  if ((DATA_IN_CNT >= DATA_IN_SIZE) && (millis() - lastComputeTime > COMPUTE_PERIOD_MS)) {
    Serial.printf("\n\nSEND!!!\n\n");
    digitalWrite(LED_BUILTIN, LOW);

    int oI = 0;
    Board mBoard;
    std::vector<Board> mMoves;

    while (oI < DATA_OUT_SIZE) {
      mBoard.resetBoard();

      for (int i = 0; i < DATA_IN_SIZE; i++) {
        ESP.wdtFeed();

        // INPUT PLAYER
        mMoves.clear();
        mBoard.getMoves(Board::PLAYER_INPUT, mMoves);

        if (mMoves.size() == 0) break;
        mBoard.setFromBoard(&mMoves[DATA_IN[i] % mMoves.size()]);

        // ALPHABETA PLAYER
        mMoves.clear();
        mBoard.getMoves(Board::PLAYER_ALPHABETA, mMoves);

        if (mMoves.size() == 0) {
          break;
        } else {
          int maxV = -1000;
          int maxM = 0;
          for (int m = 0; m < mMoves.size(); m++) {
            int v = Board::minimax(mMoves[m], 1, -1000, 1000, true, Board::PLAYER_ALPHABETA);
            if (v > maxV) {
              maxV = v;
              maxM = m;
            }
          }

          mBoard.setFromBoard(&mMoves[maxM]);

          DATA_OUT[oI++] = (uint8_t)(0xDE);
          DATA_OUT[oI++] = (uint8_t)(0xAD);
          DATA_OUT[oI++] = (uint8_t)((maxM) & 0xFF);
          DATA_OUT[oI++] = (uint8_t)((maxV) & 0xFF);
          DATA_OUT[oI++] = (uint8_t)((maxM * maxV) & 0xFF);
          DATA_OUT[oI++] = (uint8_t)(0xBE);
          DATA_OUT[oI++] = (uint8_t)(0x7A);

          for (int x = 0; (x < Board::SQUARE_LENGTH) && (oI < DATA_OUT_SIZE); x++) {
            for (int y = 0; (y < Board::SQUARE_LENGTH) && (oI < DATA_OUT_SIZE); y++) {
              DATA_OUT[oI++] = (uint8_t)((mBoard.square[x][y]) & 0xFF);
            }
          }
          if (oI >= DATA_OUT_SIZE) break;
        }
        if (oI >= DATA_OUT_SIZE) break;
      }
    }

    DATA_IN_CNT = 0;
    lastComputeTime = millis();
  }

  if (millis() - lastTxTime > TX_PERIOD_MS) {
    for (int k = 0; k < (DATA_OUT_SIZE / BEACON_PACKET_DATA_SIZE); k++) {
      memcpy(&beaconPacket[BEACON_PACKET_INDEX_DATA], DATA_OUT + (k * BEACON_PACKET_DATA_SIZE), BEACON_PACKET_DATA_SIZE);
      wifi_send_pkt_freedom(beaconPacket, BEACON_PACKET_SIZE, 0);
      delay(1);
    }

    lastTxTime = millis();
    digitalWrite(LED_BUILTIN, HIGH);
  }
}