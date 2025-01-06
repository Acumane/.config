# Enter DPMS standby after 60s idle on lockscreen
DOTS="/home/bren/dotfiles"
exec &> /dev/null

# User-activated (-f): force standby
if [ "$1" = "-f" ]; then
    hyprlock --immediate &
    sleep 2 && hyprctl dispatch dpms off
    swayidle -w timeout 1 '' resume "kill \$(pgrep -n swayidle)"
fi

wayidle -t 60 hyprctl dispatch dpms off & iPID=$!
hyprlock
if [[ $? -eq 0 || $? -eq 2 ]]; then
    kill $iPID
fi
