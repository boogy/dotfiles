# https://github.com/koekeishiya/yabai/issues/725#issuecomment-786958606
create_spaces()
{
  spaces=$(($1-$(yabai -m query --spaces | grep -c "id")+$(yabai -m query --spaces | grep -c '"native-fullscreen":1')))
  open -a "Mission Control"
  osascript -e "repeat \"$spaces\" times" -e "tell application \"System Events\" to click button 1 of group \"Spaces Bar\" of group 1 of group \"Mission Control\" of process \"Dock\"" -e "end repeat"
  open -a "Mission Control"
}

create_spaces $1
