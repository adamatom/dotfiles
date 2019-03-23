#!/usr/bin/env bash

export GREEN="#a5c261"
export ORANGE="#cc7833"
gray1_1="#353A3F"
gray1_2="#404b50"
gray1_3="#455255"

gray2_1="#353A3F"
gray2_2="#404b50"

export FG=${1:-#e6e1dc}
export BG=${2:-#2b2b2b}
export ACTIVE=${3:-#6d9cbe}

i3_bg=#363748
i3_focused_fg=${FG}
i3_focused_bg=${ACTIVE}
i3_visible_fg=${i3_bg}
i3_visible_bg=${ACTIVE}
i3_unfocused_fg=${ACTIVE}
i3_urgent_fg=${FG}
i3_urgent_bg=#ff000f

arrowright_highlight=#303030

strip1=("${gray1_1}" "${gray1_2}" "${gray1_3}" "${gray1_2}" "${gray1_1}" "${BG}")
strip2=("${gray2_1}" "${gray2_2}")


function colorme() {
    declare -a cstrip=("${!1}")
    local index=$2
    local formatstr="$3"
    local i=$(( index % ${#cstrip[*]}))
    local bgcolor=${cstrip[$i]}
    local prevbgcolor=""

    if [ $(( index )) -eq 0 ]; then
        prevbgcolor=$arrowright_highlight
    else
        i=$(( (index - 1) % ${#cstrip[*]} ))
        prevbgcolor=${cstrip[$i]}
    fi

    echo "%{T2}%{F${prevbgcolor} B${bgcolor}}%{B-F-}%{T-}%{T1}%{F${FG} B${bgcolor}}${formatstr}%{T-}%{B-F-}"
}


killall polybar

export I3_FOCUSED="%{T2}%{F${i3_bg} B${i3_focused_bg}}%{T-}%{F${i3_focused_fg}}%name%%{T2}%{F${i3_focused_bg} B${i3_bg}}%{F-B-}%{T-}"
export I3_UNFOCUSED="%{F${i3_unfocused_fg} B${i3_bg}} %name% %{F-B-}"

export I3_VISIBLE="%{T2}%{F${i3_bg} B${i3_visible_bg}}%{T-}%{F${i3_visible_fg}}%name%%{T2}%{F${i3_visible_bg} B${i3_bg}}%{F-B-}%{T-}"
export I3_URGENT="%{T2}%{F${i3_bg} B${i3_urgent_bg}}%{T-}%{F${i3_urgent_fg}}%name%%{T2}%{F${i3_urgent_bg} B${i3_bg}}%{F-B-}%{T-}"
export ARROWLEFT="%{T2}%{F${i3_bg} B${BG}}%{F-B-}%{T-}"
export WINDOWTEXT="%{F${FG} B${BG}}%title:0:100:...%%{F-B-}"
export ARROWRIGHT="%{T2}%{F${BG} B${arrowright_highlight}}%{F-B-}%{T-}"

# shellcheck disable=SC2155
{
export AUDIO_OUT=$(colorme strip1[@] 0 "<label>")
export PKG=$(colorme strip1[@] 1 "<label>")
export WG0_CLIENT=$(colorme strip1[@] 2 "<label> ")
export BLUETOOTH=$(colorme strip1[@] 3 "<label> ")
export BATTERY_FULL=$(colorme strip1[@] 4 "  <label-full>")
export BATTERY_CHARGING=$(colorme strip1[@] 4 " <animation-charging> <label-charging>")
export BATTERY_DISCHARGING=$(colorme strip1[@] 4 " <ramp-capacity> <label-discharging>")
export BATTERY_CHARGING_FG=${GREEN}
export BATTERY_DISCHARGING_FG=${ORANGE}
export TIME=$(colorme strip1[@] 5 "<label>")

export FS_MOUNTED="$(colorme strip2[@] 0 "<label-mounted>")"
export FS_UNMOUNTED=$(colorme strip2[@] 0 "<label-unmounted>")
export CPU=$(colorme strip2[@] 1 " <ramp-coreload>")
export MEM=$(colorme strip2[@] 2 " <label>")

}

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main &
    MONITOR=$m polybar --reload bottom &
  done
else
  polybar --reload main &
  polybar --reload bottom &
fi
