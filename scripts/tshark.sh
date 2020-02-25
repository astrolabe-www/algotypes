#!/bin/bash

faces=(`ifconfig | grep -o 'wlan[0-9]'`)
for x in "${faces[@]}"
do
    isused=`ifconfig "$x" | grep inet | wc -l`
    if [ "$isused" -eq 0 ]
    then
        foundface=$x
        echo "Found unused interface: $foundface"
        break
    fi
    lastface=$x
done

if [[ -z ${foundface+x} ]]
then
    if [[ "${#faces[@]}" -gt 1 ]]
    then
        foundface=$lastface
        echo "Found redundant interface: $foundface"
        sudo nmcli d disconnect "$lastface"
    elif [[ "$#" -gt 0 ]]
    then
        ifconfig "$1" &> /dev/null
        if [ $? -eq 0 ]
        then
            foundface=$1
            echo "Found argument-forced interface: $foundface"
        fi
    fi
fi

if [ -z ${foundface+x} ]
then
    echo "ERROR: couldn't find an available interface"
    exit 1
else
    echo "using: $foundface"
    ifconfig "$foundface" down
    iwconfig "$foundface" mode Monitor
    ifconfig "$foundface" up
    tshark -i "$foundface" -p -I -f "type mgt subtype probe-req" -o "gui.column.format:\"No.\",\"%m\",\"Source\",\"%s\",\"Info\",\"%i\"" -l 2>/dev/null | sed -u 's/, FN=0, Flags=........C,//g' | sed -u 's/ (Broadcast)//g'
fi
