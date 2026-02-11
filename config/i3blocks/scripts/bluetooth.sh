#!/usr/bin/env bash
# This shell script is PUBLIC DOMAIN. You may do whatever you want with it.
# Left click


#!/usr/bin/env bash
# This shell script is PUBLIC DOMAIN. You may do whatever you want with it.
# Left click
if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    blueman-manager
fi



icon_color=${icon_color:-}
# GET_BLUE=$(rfkill list bluetooth | grep yes)
GET_BLUE=$(bluetoothctl devices | cut -f2 -d' ' | while read uuid; do bluetoothctl info $uuid; done|grep -e "Connected: yes"  | wc -l)
# if [[ $GET_BLUE == *"yes"* ]]
if [[ $GET_BLUE -gt "0" ]]
#if [[ "$status1" -gt "0" ]]
then
    
    #echo ""
    echo "B"
    
else
    
    echo "B"
    echo
    echo $icon_color
fi


exit 0