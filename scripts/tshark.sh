#!/bin/bash

if [ "$#" -gt 0 ]
then
    ifconfig "$1" down
    iwconfig "$1" mode Monitor
    ifconfig "$1" up
    tshark -i "$1" -p -I -f "type mgt subtype probe-req"
else
    echo "ERROR: please provide a network interface (eg. wlan0, etc)"
fi
