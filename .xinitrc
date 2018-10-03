#!/bin/sh
#
# ~/.xinitrc
#
# Automatically sourced by startx (run your window manager from here)

# shellcheck source=.xprofile
[ -f ~/.xprofile ] && . "$HOME/.xprofile"
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ "$(command -v xautolock)" ] && systemd-run --user xautolock -time 15 -locker lock.sh &
[ "$(command -v xbanish)" ] && systemd-run --user xbanish &

xinput -set-prop "AlpsPS/2 ALPS DualPoint Stick" "Device Enabled" 0
xset m 3 10

monitors=$(xrandr | grep " connected" | cut -d " " -f 1 | sort -h | tr '\n' ' ' | sed 's/ $/\n/')

setup_for_fourk() {
    gsettings set org.gnome.desktop.interface scaling-factor 2
    gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <2>}]"
    export GDK_SCALE=2
    xrandr --dpi 158 --output DP-0 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-2 --off --output DP-1 --off --output DP-3 --primary --mode 3840x2160 --pos 3840x0 --rotate normal
    xset m 3 10
    xrdb -merge ~/.Xresources.4K
}

setup_for_lvds() {
    gsettings set org.gnome.desktop.interface scaling-factor 1
    gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <1>}]"
    export GDK_SCALE
    xrandr --dpi 130
    xrdb -merge ~/.Xresources.lvds
}

case "$2" in
    # Allow user to force a config
    i34k) setup_for_fourk;;
    lvds) setup_for_lvds;;
    *) # Auto-detect
        if [ "$monitors" = "DP-0 DP-2 DP-3" ]; then
            setup_for_fourk
        else
            setup_for_lvds
        fi;;
esac

exec i3 -c ~/.config/i3/config
