#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "Run this script as root"
	exit
fi

# Unnstall packages
apt purge -y dnsmasq hostapd

# Backup configs
mv /etc/wpa_supplicant/wpa_supplicant.conf.original /etc/wpa_supplicant/wpa_supplicant.conf 2> /dev/null
mv /etc/dnsmasq.conf.original /etc/dnsmasq.conf 2> /dev/null
mv /etc/hostapd/hostapd.conf.original /etc/hostapd/hostapd.conf 2> /dev/null
mv /etc/dhcpd.conf.original /etc/dhcpd.conf 2> /dev/null

