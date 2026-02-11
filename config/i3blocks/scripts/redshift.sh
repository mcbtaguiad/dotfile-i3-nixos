#!/usr/bin/env bash
# This shell script is PUBLIC DOMAIN. You may do whatever you want with it.




# Left click
if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    i3-msg -q -- exec ~/.local/bin/toggle-redshift
fi


icon_color=${icon_color:-}
#status=$(pgrep redshift)
status=$(pidof redshift)
if [[ -n "$status" ]]
then
    #echo ""
    echo "R"
else
    #echo ""
    echo "R"
    #echo ""
    echo
    echo $icon_color
fi


exit 0




