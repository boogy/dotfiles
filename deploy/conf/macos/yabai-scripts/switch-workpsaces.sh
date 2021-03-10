# https://github.com/koekeishiya/yabai/issues/725#issuecomment-786958606
move_to_space()
  {
    CURRENT_SPACE=$(yabai -m query --spaces| jq '[.[]|select(.focused==1)][0].index')
    TOTAL_SPACES=$(yabai -m query --spaces| jq '. | length')
    DESIRED_SPACE=$1

    if [ $DESIRED_SPACE -lt $CURRENT_SPACE ]; then
      n=0
        while [ "$n" -lt  $((CURRENT_SPACE - DESIRED_SPACE)) ]; do
          osascript -e "tell application \"System Events\" to key code 123 using control down"
          n=$(( n + 1 ))
        done
    fi
    if [ $DESIRED_SPACE -gt $CURRENT_SPACE ]; then
      n=0
      while [ "$n" -lt $((DESIRED_SPACE - CURRENT_SPACE)) ]; do
        osascript -e "tell application \"System Events\" to key code 124 using control down"
        n=$(( n + 1 ))
      done
    fi
  }

move_to_space $1
