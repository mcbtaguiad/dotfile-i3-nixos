#!/bin/bash

AVERAGE_TEMP=$(nvidia-smi -q -a | grep -i "GPU Current" | grep "[0-9]*" -o | sed -n 1p)



if (( "${AVERAGE_TEMP}" < "25" )); then
    #echo " ${AVERAGE_TEMP}°C"
    echo " ${AVERAGE_TEMP}°C"
elif (( ${AVERAGE_TEMP} > 25 && ${AVERAGE_TEMP}  < 50 )); then
    #echo " ${AVERAGE_TEMP}°C"
    echo " ${AVERAGE_TEMP}°C"
elif (( ${AVERAGE_TEMP} > 50 && ${AVERAGE_TEMP} < 75 )); then
    #echo " ${AVERAGE_TEMP}°C"
    echo " ${AVERAGE_TEMP}°C"
else
    #echo " ${AVERAGE_TEMP}°C"
    echo " ${AVERAGE_TEMP}°C"
fi

#echo $usage
