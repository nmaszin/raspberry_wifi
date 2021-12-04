#!/usr/bin/env bash

INTERFACE="wlan0"
SSID="NLocker"
PASSWORD="haslo123"
NETWORK="10.0.0.0"
NETWORK_MASK=24

RASPBERRY_IP="10.0.0.1"
FIRST_IP="10.0.0.2"
LAST_IP="10.0.0.5"

DOMAIN="raspberry.local"
SERVER_PORT=80
SSL_ENABLED=1

if [[ $EUID -ne 0 ]]; then
	echo "Run this script as root"
	exit
fi


# Install packages
apt install -y dnsmasq hostapd
python3 -m pip install flask pyopenssl

systemctl unmask hostapd
systemctl enable hostapd
systemctl enable dnsmasq

systemctl stop dnsmasq
systemctl stop hostapd
systemctl stop wpa_supplicant
systemctl stop dhcpcd

# Backup configs
mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.original 2> /dev/null
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.original 2> /dev/null
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.original 2> /dev/null
mv /etc/dhcpd.conf /etc/dhcpd.conf.original 2> /dev/null

# Setup configs
mkdir -p ./tmp
cat configs/hostapd.conf | sed "s/#SSID#/$SSID/" | sed "s/#PASSWORD#/$PASSWORD/" | sed "s/#INTERFACE#/$INTERFACE/" > ./tmp/hostapd.conf
cat configs/dhcpcd.conf | sed "s/#INTERFACE#/$INTERFACE/" | sed "s/#IP#/$RASPBERRY_IP\/$NETWORK_MASK/" > ./tmp/dhcpcd.conf
cat configs/dnsmasq.conf | sed "s/#INTERFACE#/$INTERFACE/" | sed "s/#FIRST_IP#/$FIRST_IP/" | sed "s/#LAST_IP#/$LAST_IP/" | sed "s/#RASPBERRY_IP#/$RASPBERRY_IP/" | sed "s/#DOMAIN#/$DOMAIN/"  > ./tmp/dnsmasq.conf

# Move configs
mv ./tmp/hostapd.conf /etc/hostapd/hostapd.conf
mv ./tmp/dhcpcd.conf /etc/dhcpcd.conf
mv ./tmp/dnsmasq.conf /etc/dnsmasq.conf

rm -r ./tmp

systemctl start dhcpcd
systemctl start wpa_supplicant
systemctl start dnsmasq
systemctl start hostapd


