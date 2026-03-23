#!/usr/bin/env bash

set -euo pipefail

battery_path=""
for candidate in /sys/class/power_supply/BAT*; do
    if [ -d "$candidate" ]; then
        battery_path="$candidate"
        break
    fi
done

if [ -z "$battery_path" ]; then
    printf '{"text":"No battery","class":["missing"]}\n'
    exit 0
fi

read_file() {
    local path="$1"
    if [ -f "$path" ]; then
        cat "$path"
    fi
}

capacity="$(read_file "$battery_path/capacity")"
status="$(read_file "$battery_path/status")"
current_now="$(read_file "$battery_path/current_now")"
voltage_now="$(read_file "$battery_path/voltage_now")"
power_now="$(read_file "$battery_path/power_now")"

if [ -z "${capacity:-}" ]; then
    capacity=0
fi

if [ -n "${power_now:-}" ]; then
    power_uw="$power_now"
elif [ -n "${current_now:-}" ] && [ -n "${voltage_now:-}" ]; then
    power_uw="$(awk -v current="$current_now" -v voltage="$voltage_now" 'BEGIN { printf "%.0f", (current * voltage) / 1000000 }')"
else
    power_uw=0
fi

watts="$(awk -v power_uw="$power_uw" 'BEGIN { printf "%.1f", power_uw / 1000000 }')"

sign=""
status_class="unknown"
case "$status" in
    Charging)
        sign="-"
        status_class="charging"
        ;;
    Discharging)
        sign="+"
        status_class="discharging"
        ;;
    Full)
        status_class="full"
        ;;
    Not\ charging)
        status_class="not-charging"
        ;;
esac

if [ "$capacity" -le 15 ]; then
    level_class="critical"
elif [ "$capacity" -le 30 ]; then
    level_class="warning"
else
    level_class="normal"
fi

if [ "$capacity" -le 10 ]; then
    icon=""
elif [ "$capacity" -le 35 ]; then
    icon=""
elif [ "$capacity" -le 60 ]; then
    icon=""
elif [ "$capacity" -le 85 ]; then
    icon=""
else
    icon=""
fi

if [ "$status" = "Full" ]; then
    power_text="0.0W"
else
    power_text="${sign}${watts}W"
fi

tooltip="$status"
if [ -n "$status" ]; then
    tooltip="$status: $power_text"
fi

printf '{"text":"%s%% %s  %s","tooltip":"%s","class":["%s","%s"],"percentage":%s}\n' \
    "$capacity" \
    "$icon" \
    "$power_text" \
    "$tooltip" \
    "$status_class" \
    "$level_class" \
    "$capacity"
