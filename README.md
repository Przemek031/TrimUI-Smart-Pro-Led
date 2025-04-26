# LED Temperature and Battery Monitor for TrimUI Smart Pro

This script allows you to monitor your device's CPU temperature and battery level by controlling the LED lights on the TrimUI Smart Pro. The left joystick LED shows the CPU temperature, while the right joystick LED shows the battery charge level. The LED colors change based on the current status, providing a visual representation of the device's temperature and battery condition.

⚠️ **Not responsible for anything that happens to your device. Use at your own risk.**

## 🚀 Features

### LED Temperature Monitor (Left Joystick LED)
- **CPU Temperature-based LED Color Changes**:
  - Temps below 40°C: Green LED
  - Temps between 40°C and 50°C: Yellow LED
  - Temps between 50°C and 60°C: Orange LED
  - Temps above 60°C: Red LED
  
### LED Battery Level Monitor (Right Joystick LED)
- **Battery Level-based LED Color Changes**:
  - Battery over 90%: Green LED
  - Battery between 70% and 90%: Chartreuse Green LED
  - Battery between 50% and 70%: Yellow LED
  - Battery between 30% and 50%: Orange LED
  - Battery between 20% and 30%: Red-Orange LED
  - Battery under 20%: Red LED

### Continuous Monitoring
- The script runs in the background, checking both CPU temperature and battery level every 5 seconds, and updates the LED colors accordingly for real-time status feedback.

## 📥 Installation

1. Copy the script into `/mnt/SDCARD/System/etc/led_config.sh`.
2. Set the script as executable: ```bash `chmod +x /mnt/SDCARD/System/etc/led_config.sh`
3. Run the script to start monitoring: `/mnt/SDCARD/System/etc/led_config.sh &`
4. Optionally, configure it to run on boot or from a TrimUI application. Update the system JSON configuration by running:
   `/mnt/SDCARD/System/bin/jq --arg script_name "led_config" '. += {"LEDS": $script_name}' /mnt/SDCARD/System/etc/crossmix.json`

## 🛠️ Usage
Once installed, the left joystick LED will display the CPU temperature, and the right joystick LED will display the battery level.
The CPU temperature is read from /sys/class/thermal/thermal_zone0/temp.
The battery level is read from /sys/devices/platform/soc/7081400.s_twi/i2c-6/6-0034/axp2202-bat-power-supply.0/power_supply/axp2202-battery/capacity.
The script runs indefinitely, updating the LEDs every 5 seconds.

##⚠️ Warning
This script directly interacts with your device's hardware, including controlling LED behaviors.
Use this script responsibly and monitor its behavior during the first few uses to ensure it functions as expected.

##💡 Tips
To stop the script or change the LED behaviors, simply terminate the script or modify the LED functions in the script itself.

   
