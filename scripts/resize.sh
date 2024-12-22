#!/bin/bash

D="hyprctl dispatch"
read W H < <(hyprctl monitors -j | jq -r '.[0] | "\(.width) \(.height)"')
min_W=$((W * 15 / 100)); min_H=$((H * 15 / 100))

if [[ $(hyprctl activewindow -j | jq -r '.floating') == "true" ]]; then
    size=$(hyprctl activewindow -j | jq -r '[.size[0], .size[1]]')
    w=$(echo $size | jq -r '.[0]'); h=$(echo $size | jq -r '.[1]')

    resize() {
        cur=$1; min=$2; amt=$3; dir=$4
        if [[ $cur -gt $((min + amt)) ]]; then echo "$amt"
        elif [[ $cur -gt $min ]]; then echo "$((cur - min))"
        fi
    }

    case $1 in
        l) if dec=$(resize $w $min_W 125 l); then
               $D resizeactive -$dec 0; $D moveactive $((dec/2)) 0
           fi;;
        r) $D resizeactive 125 0; $D moveactive -62 0;;
        u) if dec=$(resize $h $min_H 75 u); then
               $D resizeactive 0 -$dec; $D moveactive 0 $((dec/2))
           fi;;
        d) $D resizeactive 0 75; $D moveactive 0 -37;;
    esac
else
    dim=$(case $1 in l|r) echo width;; *) echo height;; esac)
    dir=$(case $1 in l|u) echo prev;; r|d) echo next;; esac)
    $D scroller:cycle$dim $dir
fi
