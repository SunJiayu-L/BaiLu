#!/bin/bash

# This script checks permissions and then flashes your device

echo "===== BaiLu Flashing Script ====="
echo "Checking ST-Link permissions..."

# Check if ST-Link is accessible
if lsusb | grep -q "0483:374b\|0483:3748\|0483:3752\|0483:3744"; then
    echo "ST-Link device found!"
    
    # Find all USB devices that match the ST-Link vendor ID and check permissions
    PERMISSION_ISSUE=false
    for dev in $(find /dev/bus/usb -type c); do
        if udevadm info -q property -n $dev 2>/dev/null | grep -q "ID_VENDOR_ID=0483"; then
            if [ ! -w "$dev" ]; then
                PERMISSION_ISSUE=true
                echo "Permission issue detected for $dev"
                echo "Attempting to fix..."
                if sudo chmod 666 $dev; then
                    echo "✓ Permission fixed!"
                else
                    echo "✗ Failed to fix permission"
                    exit 1
                fi
            fi
        fi
    done
    
    if [ "$PERMISSION_ISSUE" = true ]; then
        echo "Permissions have been updated. Proceeding with flashing..."
    else
        echo "Permissions look good. Proceeding with flashing..."
    fi
    
    # Run the flashing command
    echo "Starting OpenOCD to flash the device..."
    openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program build/bailu.elf verify reset exit"
    
    if [ $? -eq 0 ]; then
        echo "✓ Flashing completed successfully!"
    else
        echo "✗ Flashing failed."
        echo "If you continue having issues, try:"
        echo "1. Running the full permission fix script: sudo ./fix_stlink_permissions.sh"
        echo "2. Unplugging and replugging your ST-Link device"
        echo "3. Logging out and back in to refresh group permissions"
    fi
else
    echo "No ST-Link devices found. Is your programmer connected?"
    exit 1
fi
