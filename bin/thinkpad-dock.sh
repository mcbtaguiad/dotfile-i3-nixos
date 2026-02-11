#!/usr/bin/env bash

# Save this file as /etc/sbin/thinkpad-dock.sh

# NB: you will need to modify the username and tweak the xrandr
# commands to suit your setup.

# wait for the dock state to change
sleep 1

username=$USER

if [[ "$ACTION" == "add" ]]; then
  DOCKED=1
  logger -t DOCKING "Detected condition: docked"
elif [[ "$ACTION" == "unbind" ]]; then
  DOCKED=0
  logger -t DOCKING "Detected condition: un-docked"
else
  logger -t DOCKING "Detected condition: un-docked"
  exit 1
fi


function switch_to_local {
  export DISPLAY=$1

  su $username -c '
  sleep 1
  autorandr --skip-option crtc -c mobile 
  nitrogen --restore  
    '
}

function switch_to_external {
  export DISPLAY=$1

  su $username -c '
  sleep 1
	autorandr --skip-option crtc -c docked-p 
  nitrogen --restore  
   '
# Switching both external monitors at once can cause "Configure crtc 2 failed"
#  su $username -c '
#	xrandr --output eDP1 --off --primary \
#		--output HDMI1 --off \
#		--output HDMI2 --off \
#		--output DP1 --off --output DP2 --off \
#		--output DP2-1 --off \
#		--output DP2-2 --primary --crtc 1 --mode 1920x1080 --pos 0x0 \
#		--output DP2-3 --right-of DP2-2 --crtc 0 --mode 1920x1080 --pos 1920x0
#	'
}

case "$DOCKED" in
  "0")
    #undocked event
    switch_to_local :0 ;;
  "1")
    #docked event
    switch_to_external :0 ;;
esac