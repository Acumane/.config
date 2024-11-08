#!/bin/bash

pgrep -x rofi && exit

y=""
case $1 in
    "run")  rofi -show drun -normal-window -show-icons & y="105";;
    "copy") cliphist list | rofi -normal-window -dmenu -display-columns 2 -p "COPY" \
            -theme-str "listview{lines:6;columns:1;} window{width:375px;}" \
            | cliphist decode | wl-copy & y="75";;
    "emoji") rofimoji --selector-args="-normal-window \
            -theme-str 'listview{lines:4;columns:6;fixed-columns:true;flow:horizontal;} element-text{font:\"Akkurat 13\";} element{padding:11px;margin:3px;}'" \
            --hidden-descriptions -s neutral --max-recent 0 -r EMOJI & y="75";;
    "cmd")  zsh -c "$(rofi -normal-window -dmenu -p "CMD" \
            -theme-str 'listview{enabled:false;} entry{font:"JetBrains Mono 10";} window{width:450px;}' &)" & y="180"
esac

while ! hyprctl clients | grep -q "class: Rofi"; do sleep 0.05; done

pkill -USR1 waybar
hyprctl dispatch "movewindowpixel 0 -${y},Rofi"

{ while pgrep -x rofi > /dev/null; do # kill if focus is lost
    if [[ $(hyprctl activewindow -j | jq -r .class) != "Rofi" ]]; then
        pkill rofi; break
    fi
    sleep 0.1
done } &

wait
pkill -USR1 waybar
