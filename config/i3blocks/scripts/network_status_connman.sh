#!/usr/bin/env bash

# ConnMan i3blocks network monitor
# adapted from NetworkManager version

if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    i3-msg -q exec alacritty -e connmanctl &
fi

icon_color=${icon_color:-}

mapfile -t services < <(connmanctl services | grep '^\*')

network_count=${#services[@]}

if (( network_count == 0 )); then
    echo "DOWN"
    echo
    echo "$icon_color"
    exit 0
fi

for line in "${services[@]}"; do
    service_id=$(awk '{print $NF}' <<< "$line")
    service_name=$(sed -E 's/^\*.. //' <<< "$line" | sed 's/[[:space:]]\+[a-z0-9_]*$//')

    if [[ $service_id == wifi_* ]]; then
        output4+=("WIFI")
    elif [[ $service_id == ethernet_* ]]; then
        output4+=("ETH")
    elif [[ $service_id == vpn_* ]]; then
        output4+=("VPN")
    elif [[ $service_id == tun_* ]]; then
        output4+=("TUN")
    else
        output4+=("NET")
    fi
done

end=$((network_count - 1))

for i in $(seq 0 $end); do
    message+=" ${output4[$i]} "
done

echo "$message"
