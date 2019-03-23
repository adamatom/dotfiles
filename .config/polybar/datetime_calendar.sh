#!/bin/sh

DATE="$(date +"%a %b %d, %H:%M ")"

case "$1" in
    --popup)
        gnome-calendar 2>/dev/null &

        ;;
    *)
        echo "$DATE"
        ;;
esac
