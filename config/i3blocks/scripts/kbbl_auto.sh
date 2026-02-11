#!/bin/sh

if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    toggle-kbbl
fi

icon_color=${icon_color:-}
status=$(sudo systemctl status tp-auto-kbbl | grep -c 'running')

if [[ "$status" -gt "0" ]]
then
    echo "K"
    # echo ""?
else
    
    echo "K"
    # echo ""
    echo
    echo $icon_color
    #echo \#70797C 
    #839275
    #575758
fi


exit 0
