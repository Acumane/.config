#!/bin/bash

for _ in {1..10}; do
    sleep 0.08

    addr=$(echo "$1" | jq -r '.address')
    title=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$addr\") | .title")

    if [[ "$title" =~ ^(Extension|Sign in) ]]; then
        hyprctl --batch "dispatch setfloating address:$addr; \
                         dispatch resizewindowpixel exact 800 560, address:$addr; \
                         dispatch focuswindow address:$addr; \
                         dispatch centerwindow";
        exit 0
    fi
done
