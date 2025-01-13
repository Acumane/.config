#!/bin/bash

T=1
TO="/tmp/gap_TO"
LAST_ADDR="/tmp/last_win"

win_addr=$(echo "$1" | jq -r .address)
floating=$(echo "$1" | jq -r .floating)

[ "$floating" = "true" ] && exit 0

# Check if it's the same window
if [ -f "$LAST_ADDR" ]; then
    last_addr=$(cat "$LAST_ADDR")
    [ "$win_addr" = "$last_addr" ] && exit 0
fi

echo "$win_addr" > "$LAST_ADDR"

hyprctl keyword general:gaps_in 16
hyprctl keyword general:gaps_out 32


date +%s > "$TO"
sleep $T

t_last=$(cat "$TO")
t_now=$(date +%s)

if [ $((t_now - t_last)) -ge $T ]; then
    hyprctl keyword general:gaps_in 4
    hyprctl keyword general:gaps_out 2
fi
