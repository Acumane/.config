# Enter DPMS standby after 60s idle on lockscreen

exec &> /dev/null

# User-activated (-f): force standby
if [ "$1" = "-f" ]; then
    pidof hyprlock || hyprlock --immediate &
    sleep .5s; brillo -O; brillo -S 0% -u 1000000; blight set 0 & hyprctl dispatch dpms off
    swayidle -w timeout 1 '' resume "brillo -I -u 100000 && kill \$(pgrep -n swayidle)"
    exit
fi

# Immediate (-i): lockscreen only
[ "$1" = "-i" ] && { pidof hyprlock || hyprlock --immediate & exit; }

# Passive (battery): fade (50s), lock (1m30s), backlight off (1m33s), suspend (2m30s)
swayidle \
timeout 50 "(acpi -a | grep -q off) && (brillo -O; brillo -S 0% -u 3000000)" resume "pkill brillo; brillo -I -u 150000" \
timeout 90 "(acpi -a | grep -q off) && (pidof hyprlock || hyprlock & hyprctl dispatch dpms off)" \
timeout 93 "(acpi -a | grep -q off) && blight set 0" resume "brillo -I -u 150000" \
timeout 150 "(acpi -a | grep -q off) && systemctl suspend" after-resume "brillo -I -u 150000" \
timeout 170 "(acpi -a | grep -q on) && (brillo -O; brillo -S 0% -u 3000000)" resume "pkill brillo; brillo -I -u 150000" \
timeout 210 "(acpi -a | grep -q on) && (pidof hyprlock || hyprlock & hyprctl dispatch dpms off)" \
timeout 213 "(acpi -a | grep -q on) && blight set 0" resume "brillo -I -u 150000" \
# Passive (charging): fade (2m50s), lock (3m30s), backlight off (3m33s)
