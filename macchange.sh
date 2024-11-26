#!/bin/bash
# Replace "interface_name" with your network interface name
interface_name="wlan0"

# Disable the network interface
sudo ifconfig $interface_name down

# Change the MAC address to a random address
sudo macchanger -r $interface_name

# Re-enable the network interface
sudo ifconfig $interface_name up
