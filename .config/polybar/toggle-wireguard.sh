#!/usr/bin/env bash

wg_if="$1"
wg_inactive=$(ip address show "${wg_if}" 2>&1 | grep 'does not exist')

if [ "${wg_inactive}" = "" ]; then
    sudo wg-quick down "${wg_if}"
else
    sudo wg-quick up "${wg_if}"
fi
