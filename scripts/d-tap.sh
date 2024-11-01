#!/bin/bash

prev=0
trap "exit 0" SIGINT SIGTERM

libinput debug-events | while read -r line; do
    if [[ $line =~ "TOUCH_UP" ]]; then
        now=$(date +%s.%N)
        if (( $(echo "$now - $prev < 0.3" | bc -l) )); then
            sh $SCRIPTS/max.sh
            sleep 0.5 # rate limit
        fi
        prev=$now
    fi
done
