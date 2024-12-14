#!/bin/bash

meta=false; overview=false

keyd monitor | while read -r line; do
    if [[ $line == *"leftmeta up"* ]]; then
        if [ "$overview" = true ]; then
            hyprctl dispatch "scroller:toggleoverview"
            overview=false
            hyprctl reload
        fi
        meta=false
    elif [[ $line == *"leftmeta down"* ]]; then
        meta=true
    elif [[ $line == *"tab down"* ]] && [ "$meta" = true ] && [ "$overview" = false ]; then
        overview=true
        hyprctl --batch "\
            dispatch scroller:toggleoverview;\
            keyword general:gaps_in 6; keyword general:border_size 4; keyword decoration:rounding 15"
    fi
done
