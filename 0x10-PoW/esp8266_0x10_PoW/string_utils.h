#include "sdk_structs.h"
#include "ieee80211_structs.h"

// Returns a human-readable string from a binary MAC address.
void mac2str(const uint8_t* ptr, char* string) {
  sprintf(string, "%02x:%02x:%02x:%02x:%02x:%02x", ptr[0], ptr[1], ptr[2], ptr[3], ptr[4], ptr[5]);
  return;
}

// Parses 802.11 packet type-subtype pair into a human-readable string
const char* wifi_pkt_type2str(wifi_promiscuous_pkt_type_t type, wifi_mgmt_subtypes_t subtype) {
  switch (type) {
    case WIFI_PKT_MGMT:
      switch (subtype) {
        case ASSOCIATION_REQ:
          return "MGMT ASSOC REQ";
        case ASSOCIATION_RES:
          return "MGMT ASSOC RES";
        case REASSOCIATION_REQ:
          return "MGMT REASSOC REQ";
        case REASSOCIATION_RES:
          return "MGMT REASSOC RES";
        case PROBE_REQ:
          return "MGMT PROBE REQ";
        case PROBE_RES:
          return "MGMT PROBE RES";
        case BEACON:
          return "MGMT BEACON";
        case ATIM:
          return "MGMT ATIM";
        case DISASSOCIATION:
          return "MGMT DISSASOC";
        case AUTHENTICATION:
          return "MGMT AUTH";
        case DEAUTHENTICATION:
          return "MGMT DEAUTH";
        case ACTION:
          return "MGMT ACTION";
        case ACTION_NACK:
          return "MGMT ACTION NACK";
        default:
          return "MGMT UNSUPPORTED";
      }

    case WIFI_PKT_CTRL:
      return "CTRL";

    case WIFI_PKT_DATA:
      return "DATA";

    default:
      return "ERROR";
  }
}
