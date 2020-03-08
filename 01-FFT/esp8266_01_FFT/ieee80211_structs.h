#ifndef _IEE80211_STRUCTS_H_
#define _IEE80211_STRUCTS_H_

#include <ESP8266WiFi.h>

typedef enum {
    WIFI_PKT_MGMT,
    WIFI_PKT_CTRL,
    WIFI_PKT_DATA,
    WIFI_PKT_MISC,
} wifi_promiscuous_pkt_type_t;

typedef enum {
    ASSOCIATION_REQ,
    ASSOCIATION_RES,
    REASSOCIATION_REQ,
    REASSOCIATION_RES,
    PROBE_REQ,
    PROBE_RES,
    NU0,
    NU1,
    BEACON,
    ATIM,
    DISASSOCIATION,
    AUTHENTICATION,
    DEAUTHENTICATION,
    ACTION,
    ACTION_NACK,
} wifi_mgmt_subtypes_t;

typedef struct {
  unsigned timestamp:64;
  unsigned interval:16;
  unsigned capability:16;
  unsigned tag_number:8;
  unsigned tag_length:8;
  char ssid[0];
  uint8 rates[1];
} wifi_mgmt_beacon_t; // 16 bytes

typedef struct {
  unsigned element_id:8;
  unsigned tag_length:8;
  char ssid[0];
}__attribute__((packed, aligned(1))) wifi_mgmt_probe_req_t; // 3 bytes

typedef struct {
    unsigned protocol:2;
    unsigned type:2;
    unsigned subtype:4;
    unsigned to_ds:1;
    unsigned from_ds:1;
    unsigned more_frag:1;
    unsigned retry:1;
    unsigned pwr_mgmt:1;
    unsigned more_data:1;
    unsigned wep:1;
    unsigned strict:1;
}__attribute__((packed, aligned(1))) wifi_header_frame_control_t; // 2 bytes

typedef struct {
    wifi_header_frame_control_t frame_ctrl;
    unsigned duration_id:16; /* duration of transmission */
    uint8_t addr1[6]; /* receiver address */
    uint8_t addr2[6]; /* sender address */
    uint8_t addr3[6]; /* bssid address */
    unsigned sequence_ctrl:16;
} wifi_ieee80211_mac_hdr_t; // 24 bytes

typedef struct {
    wifi_ieee80211_mac_hdr_t hdr;
    uint8_t payload[0]; /* network data ended with 4 bytes csum (CRC32) */
} wifi_ieee80211_packet_t;

#endif
