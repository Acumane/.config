# TODO:
# - PR to keyd-application-manager for groups
# - move "keyd reload" to alias
# - Add "idle" mode

GAME=$(hyprctl getoption animations:enabled -j | jq ".int")

if [[ "$GAME" = 1 ]]; then
    ratbagctl "G900" led 0 set color ff0f00; ratbagctl "G900" rate set 1000
    liquidctl --match h80i set logo color blackout --alert-threshold 85
    openrgb -p game.orp
    hyprctl keyword animations:enabled 0
    notify-send -u low -i - "Switched to game mode"

elif [[ "$GAME" = 0 ]]; then
    ratbagctl "G900" led 0 set color 6e6482; ratbagctl "G900" rate set 250
    liquidctl --match h80i set logo color fixed 75a6ff --alert-threshold 60
    openrgb -p main.orp
    hyprctl keyword animations:enabled 1
    notify-send -u low -i - "Switched to main mode"
fi
