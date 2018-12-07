#!/usr/bin/env bash

# depends on being called by launch script, which populates some color
# variables into the environment.
bt_blocked=$(rfkill list bluetooth 2>&1| awk '/Soft blocked: yes/ {print $3}')

if [ "${bt_blocked}" = "" ]; then
    echo -e "%{F${BLUE}}"
else
    echo -e "%{F${BG}}"
fi
