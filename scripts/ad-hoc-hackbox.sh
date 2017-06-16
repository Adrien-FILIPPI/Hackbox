#!/usr/bin/env bash
ifconfig wlan0 down
service network-manager stop
ifconfig wlan0 up
ip link set wlan0 down
iwconfig wlan0 mode ad-hoc
iwconfig wlan0 channel 2
iwconfig wlan0 essid HADHOCK
ip link set wlan0 up
ip addr add 10.2.1.2/24 dev wlan0

