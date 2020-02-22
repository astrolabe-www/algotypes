#!/bin/bash

faces=(`ifconfig | grep -o 'wlan[0-9]'`)
for x in "${faces[@]}"
do
    isused=`ifconfig "$x" | grep inet | wc -l`
    if [ "$isused" -eq 0 ]
    then
        foundface=$x
        break
    fi
    lastface=$x
done

if [[ -z ${foundface+x} ]] && [[ "${#faces[@]}" -gt 1 ]]
then
    foundface=$lastface
fi

if [ -z ${foundface+x} ]
then
    echo "ERROR: couldn't find an available interface"
    exit 1
else
    echo "using '$foundface'"
    ifconfig "$foundface" down
    iwconfig "$foundface" mode Monitor
    ifconfig "$foundface" up
    tshark -i "$foundface" -p -I -f "type mgt subtype probe-req" -o "gui.column.format:\"No.\",\"%m\",\"Source\",\"%s\",\"Info\",\"%i\"" -l 2>/dev/null | sed -u 's/, FN=0, Flags=........C,//g' | sed -u 's/ (Broadcast)//g'
fi
