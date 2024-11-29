SWAP=("capslock = overload(control, esc)" "capslock = C-")
GAME=$(hyprctl getoption animations:enabled -j | jq ".int")
KEYD="$HOME/dotfiles/keyd/global.conf"
# -k          keys-only mode
# -k reload   reload keys only (keyd)

if [ "$2" == "reload" ]; then
    cp "$KEYD" /etc/keyd/default.conf && keyd reload
    notify-send -u low -i - "keyd reloaded"
    exit
fi

if [[ "$GAME" = 1 ]]; then
    sed -i "s/${SWAP[0]}/${SWAP[1]}/" $KEYD
    sed -i '/^# Keys (game):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    sed -i '/^# Mouse (main):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    sed -i '/^# Disabled (game):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    cp $KEYD /etc/keyd/default.conf && keyd reload
    ratbagctl "G900" led 0 set color ff0f00
    ratbagctl "G900" rate set 1000

    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0"

    [[ "$1" == "-k" ]] && notify-send -i - "Keys switched to game mode" && exit

    liquidctl --match h80i set logo color blackout --alert-threshold 85
    openrgb -p game.orp
    notify-send -u low -i - "Switched to game mode"
elif [[ "$GAME" = 0 ]]; then
    sed -i "s/${SWAP[1]}/${SWAP[0]}/" $KEYD
    sed -i '/^# Mouse (main):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    sed -i '/^# Keys (game):/,/^$/{/^$/!{/^#/! s/^/# /}}' $KEYD
    sed -i '/^# Disabled (game):/,/^$/{/^#.*:$/! s/^# //}' $KEYD
    cp $KEYD /etc/keyd/default.conf && keyd reload
    ratbagctl "G900" led 0 set color 6e6482
    ratbagctl "G900" rate set 250

    hyprctl reload
    [[ "$1" == "-k" ]] && notify-send -u low -i - "Keys switched to main mode" && exit

    liquidctl --match h80i set logo color fixed 75a6ff --alert-threshold 60
    openrgb -p main.orp
    notify-send -u low -i - "Switched to main mode"
fi
