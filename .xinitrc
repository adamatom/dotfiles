#!/bin/sh
#
# ~/.xinitrc
#
# Automatically sourced by startx (run your window manager from here)

[[ -f ~/.xprofile ]] && source ~/.xprofile
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ $(command -v xautolock) ]] && xautolock -time 5 -locker lock.sh &
[[ $(command -v xbanish) ]] && xbanish &
xinput -set-prop "AlpsPS/2 ALPS DualPoint Stick" "Device Enabled" 0
killall gsd-xrandr; /usr/lib/gnome-settings-daemon/gsd-xrandr >/dev/null &
killall gsd-xsettings; /usr/lib/gnome-settings-daemon/gsd-xsettings >/dev/null &
killall gsd-clipboard; /usr/lib/gnome-settings-daemon/gsd-clipboard >/dev/null &

case "$2" in
    i34k              )
        gsettings set org.gnome.desktop.interface scaling-factor 2
        gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <2>}]"
        xrandr --dpi 184 --output DP-4 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-2 --off --output DP-1 --off --output DP-0 --primary --mode 3840x2160 --pos 3840x0 --rotate normal
        xset m 3 10
        exec i3 -c ~/.config/i3/4K;;
    *)
        xrandr --dpi 92
        gsettings set org.gnome.desktop.interface scaling-factor 1
        gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <1>}]"
        xset m 3 5
        exec i3 -c ~/.config/i3/lvds;;
esac
