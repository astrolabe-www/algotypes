#!/bin/bash


for x in $(ifconfig | grep -o 'wlan[0-9]')
do
    isused=`ifconfig "$x" | grep inet | wc -l`
    if [ "$isused" -eq 0 ]
    then
        foundface=$x
        break
    fi
done

if [ -z ${foundface+x} ]
then
    echo "ERROR: couldn't find an available interface"
    exit 1
else
    echo "using '$foundface'"
    ifconfig "$foundface" down
    iwconfig "$foundface" mode Monitor
    ifconfig "$foundface" up
    tshark -i "$foundface" -p -I -f "type mgt subtype probe-req"
fi
