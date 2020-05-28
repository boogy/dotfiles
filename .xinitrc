#xinput --set-prop "DLL06E4:01 06CB:7A13 Touchpad" "libinput Natural Scrolling Enabled" 0
#xinput --set-prop "DLL06E4:01 06CB:7A13 Touchpad" "libinput Click Method Enabled" 0 1
#xinput --set-prop "Logitech Performance MX" "Device Accel Constant Deceleration" 0.700000
#xinput --set-prop "ZLY ZELOTES GAME MOUSE" "Device Accel Constant Deceleration" 0.700000
#xset r rate 200 50
#setxkbmap -model pc105 -layout ch -variant fr -option lv3:ralt_switch
#xmodmap -e "clear lock" #disable caps lock switch
#xmodmap -e "keysym Caps_Lock = Escape" #set caps_lock as escape
#setxkbmap -option caps:escape
#loadkeys fr_CH-latin1

export DISPLAY=":0.0"
xhost +local:

exec pulseaudio --start &
exec start-pulseaudio-x11
exec i3
