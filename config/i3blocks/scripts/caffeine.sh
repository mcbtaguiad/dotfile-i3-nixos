#!/usr/bin/env bash
# This shell script is PUBLIC DOMAIN. You may do whatever you want with it.
# Left click
if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    i3-msg -q -- exec ~/.local/bin/toggle-caffeine
fi

icon_color=${icon_color:-}
pid=$(pgrep xidlehook)
status=$(ps p $pid | grep -c "Tl")

if [ "$status" -gt "0" ]
#if [[ "$status1" -gt "0" ]]
then
    #echo ""
    echo "C"
else
    #echo ""
    echo "C"
    echo
    echo $icon_color
fi


exit 0