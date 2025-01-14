#!/bin/bash

meta=false; overview=false

keyd monitor | while read -r line; do
    if [[ $line == *"leftmeta up"* ]]; then
        if [ "$overview" = true ]; then
            hyprctl reload
            overview=false
        fi
        meta=false
    elif [[ $line == *"leftmeta down"* ]]; then
        meta=true
    elif [[ $line == *"tab down"* ]] && [ "$meta" = true ] && [ "$overview" = false ]; then
        overview=true
        hyprctl --batch "keyword general:gaps_in 16; keyword general:gaps_out 64"
    fi
done
