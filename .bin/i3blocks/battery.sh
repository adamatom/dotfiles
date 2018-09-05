#!/bin/bash

BATTERY_STATE=$(echo "${BATTERY_INFO}" | upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full" | awk '{print $2}')
BATTERY_POWER=$(echo "${BATTERY_INFO}" | upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}' | tr -d '%')
URGENT_VALUE=5


if [[ "${BATTERY_STATE}" = "discharging" ]]; then
    if [[ "${BATTERY_POWER}" -gt 87 ]]; then
        BATTERY_ICON=""
    elif [[ "${BATTERY_POWER}" -gt 63 ]]; then
        BATTERY_ICON=""
    elif [[ "${BATTERY_POWER}" -gt 38 ]]; then
        BATTERY_ICON=""
    elif [[ "${BATTERY_POWER}" -gt 13 ]]; then
        BATTERY_ICON=""
    elif [[ "${BATTERY_POWER}" -le 13 ]]; then
        BATTERY_ICON=""
    else
        BATTERY_ICON=""
    fi
else
    BATTERY_ICON=""
fi

echo "${BATTERY_ICON}${BATTERY_POWER}%"
echo "${BATTERY_ICON}${BATTERY_POWER}%"
echo ""

if [[ "${BATTERY_STATE}" = "discharging" ]]; then
    if [[ "${BATTERY_POWER}" -lt 20 ]]; then
        echo "#FF0000"
        echo ""
    elif [[ "${BATTERY_POWER}" -lt 40 ]]; then
        echo "#FFAE00"
        echo ""
    elif [[ "${BATTERY_POWER}" -lt 60 ]]; then
        echo "#FFF600"
        echo ""
    elif [[ "${BATTERY_POWER}" -lt 85 ]]; then
        echo "#A8FF00"
        echo ""
    fi
    if [[ "${BATTERY_POWER}" -le "${URGENT_VALUE}" ]]; then
        exit 33
    fi
fi
