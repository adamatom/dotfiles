#!/bin/sh
#
# ~/.xinitrc
#
# Automatically sourced by startx (run your window manager from here)

[[ -f ~/.xprofile ]] && source ~/.xprofile
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ $(command -v xautolock) ]] && xautolock -time 5 -locker lock.sh &
[[ $(command -v xbanish) ]] && xbanish &
case "$2" in
    awesome           ) exec awesome;;
    bspwm             ) exec bspwm;;
    catwm             ) exec catwm;;
    cinnamon          ) exec cinnamon-session;;
    dwm               ) exec dwm;;
    enlightenment     ) exec enlightenment_start;;
    ede               ) exec startede;;
    fluxbox           ) exec startfluxbox;;
    gnome             ) exec gnome-session;;
    gnome-classic     ) exec gnome-session --session=gnome-classic;;
    i34k              ) exec i3 -c ~/.config/i3/4K;;
    i3lvds            ) exec i3 -c ~/.config/i3/lvds;;
    icewm             ) exec icewm-session;;
    jwm               ) exec jwm;;
    kde               ) exec startkde;;
    mate              ) exec mate-session;;
    monster|monsterwm ) exec monsterwm;;
    notion            ) exec notion;;
    openbox           ) exec openbox-session;;
    unity             ) exec unity;;
    xfce|xfce4        ) exec startxfce4;;
    xmonad            ) exec xmonad;;
    # No known session, try to run it as command
    *) exec i3 -c ~/.config/i3/lvds;;
esac
