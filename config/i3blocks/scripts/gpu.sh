#!/usr/bin/env bash

SAVE2=/tmp/i3blocks_gpu_usage_4

declare -A graph=(
  ["11"]="\u28C0"
  ["12"]="\u28E0"
  ["13"]="\u28F0"
  ["14"]="\u28F8"
  ["21"]="\u28C4"
  ["22"]="\u28E4"
  ["23"]="\u28F4"
  ["24"]="\u28FC"
  ["31"]="\u28C6"
  ["32"]="\u28E6"
  ["33"]="\u28F6"
  ["34"]="\u28FE"
  ["41"]="\u28C7"
  ["42"]="\u28E7"
  ["43"]="\u28F7"
  ["44"]="\u28FF"
)

# Initialize file if missing
if [[ ! -f $SAVE2 ]]; then
  echo "1 1 1 1" > "$SAVE2"
fi

# Read values safely
read -a val < "$SAVE2"

# Ensure exactly 4 values
if [[ ${#val[@]} -ne 4 ]]; then
  val=(1 1 1 1)
fi

# Get GPU usage safely
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk '{print $1}')
usage=${usage:-0}

# Update history
if (( usage >= 75 )); then
  val=("${val[@]:1:3}" 4)
elif (( usage >= 50 )); then
  val=("${val[@]:1:3}" 3)
elif (( usage >= 25 )); then
  val=("${val[@]:1:3}" 2)
else
  val=("${val[@]:1:3}" 1)
fi

# Output graph
echo -ne "${graph[${val[0]}${val[1]}]}${graph[${val[2]}${val[3]}]}"

printf "%.2f%%\n" "$usage"

# Save updated history
echo "${val[*]}" > "$SAVE2"
