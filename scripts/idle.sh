# Enter DPMS standby after 60s idle on lockscreen
exec &> /dev/null

# User-activated (-f): force standby
if [ "$1" = "-f" ]; then
    pidof hyprlock || hyprlock --immediate &
    sleep 2 && hyprctl dispatch dpms off
    swayidle -w timeout 1 '' resume "kill \$(pgrep -n swayidle)"
fi

wayidle -t 60 hyprctl dispatch dpms off & iPID=$!
pidof hyprlock || hyprlock
if [[ $? -eq 0 || $? -eq 2 ]]; then
    kill $iPID
fi
