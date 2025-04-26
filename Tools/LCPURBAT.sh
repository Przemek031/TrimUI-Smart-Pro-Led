#!/bin/sh
PATH="/mnt/SDCARD/System/bin:$PATH"
LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"

# Notify about the current script mode
/mnt/SDCARD/System/usr/trimui/scripts/infoscreen.sh -m "Applying \"$(basename "$0" .sh)\" mode..."

pkill -f "led_config.sh"

output_file="/mnt/SDCARD/System/etc/led_config.sh"
echo -n >"$output_file"

cat <<'EOF' >"$output_file"
#!/bin/sh

cpu_temp_file="/sys/class/thermal/thermal_zone0/temp"
battery_capacity_file="/sys/devices/platform/soc/7081400.s_twi/i2c-6/6-0034/axp2202-bat-power-supply.0/power_supply/axp2202-battery/capacity"

set_left_led() {
    r=$1
    g=$2
    b=$3
    echo "$(printf "%02X%02X%02X " $r $g $b)" > /sys/class/led_anim/effect_rgb_hex_l
    echo 1 > /sys/class/led_anim/effect_cycles_l
    echo 2000 > /sys/class/led_anim/effect_duration_l
    echo 1 > /sys/class/led_anim/effect_l
}

set_right_led() {
    r=$1
    g=$2
    b=$3
    echo "$(printf "%02X%02X%02X " $r $g $b)" > /sys/class/led_anim/effect_rgb_hex_r
    echo 1 > /sys/class/led_anim/effect_cycles_r
    echo 2000 > /sys/class/led_anim/effect_duration_r
    echo 1 > /sys/class/led_anim/effect_r
}

# Enable animation effect
echo 1 > /sys/class/led_anim/effect_enable

while true; do
    # Read CPU temperature
    cpu_temp=$(cat $cpu_temp_file)
    cpu_temp=$((cpu_temp / 1000))

    # Read battery level
    battery_level=$(cat $battery_capacity_file)

    # Set color for the left knob (CPU temp)
    if [ $cpu_temp -le 40 ]; then
        set_left_led 0 255 0  # Green
    elif [ $cpu_temp -le 50 ]; then
        set_left_led 255 255 0  # Yellow
    elif [ $cpu_temp -le 60 ]; then
        set_left_led 255 140 0  # Orange
    else
        set_left_led 255 0 0  # Red
    fi

    # Set color for the right knob (Battery)
    if [ $battery_level -ge 90 ]; then
        set_right_led 0 255 0  # Green
    elif [ $battery_level -ge 70 ]; then
        set_right_led 127 255 0  # Chartreuse
    elif [ $battery_level -ge 50 ]; then
        set_right_led 255 255 0  # Yellow
    elif [ $battery_level -ge 30 ]; then
        set_right_led 255 140 0  # Orange
    elif [ $battery_level -ge 20 ]; then
        set_right_led 255 69 0  # Red-orange
    else
        set_right_led 255 0 0  # Red
    fi

    sleep 5
done
EOF

chmod +x "$output_file"

"$output_file" &

script_name=$(basename "$0" .sh)

json_file="/mnt/SDCARD/System/etc/crossmix.json"
if [ ! -f "$json_file" ]; then
  echo "{}" >"$json_file"
fi
/mnt/SDCARD/System/bin/jq --arg script_name "$script_name" '. += {"LEDS": $script_name}' "$json_file" >"/tmp/json_file.tmp" && mv "/tmp/json_file.tmp" "$json_file"

# Update main UI state
/mnt/SDCARD/System/usr/trimui/scripts/mainui_state_update.sh "LEDS" "$script_name"
