#!/usr/bin/env bash

wg_if="$1"
wg_inactive=$(ip address show "${wg_if}" 2>&1 | grep 'does not exist')

if [ "${wg_inactive}" = "" ]; then
    echo -e "%{F${GREEN}}"
else
    echo -e "%{F${BG}}"
fi
