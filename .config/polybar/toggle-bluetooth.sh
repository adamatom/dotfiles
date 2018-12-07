#!/usr/bin/env bash

bt_blocked=$(rfkill list bluetooth| awk '/Soft blocked: yes/ {print $3}')

if [ "${bt_blocked}" = "" ]; then
    rfkill block bluetooth
else
    rfkill unblock bluetooth
fi
