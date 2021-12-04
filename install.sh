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

systemctl stop dnsmasq
systemctl stop hostapd

# Backup configs
mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant_conf.original
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.original
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.original
mv /etc/dhcpd.conf /etc/dhcpd.conf.original

# Setup configs
mkdir -p ./tmp
cat configs/hostapd.conf | sed "s/#SSID#/$SSID/" | sed "s/#PASSWORD#/$PASSWORD/" | sed "s/#INTERFACE#/$INTERFACE/" > ./tmp/hostapd.conf
cat configs/dhcpd.conf | sed "s/#INTERFACE#/$INTERFACE/" | sed "s/#IP#/$RASPBERRY_IP\/$NETWORK_MASK/" > ./tmp/dhcpd.conf
cat configs/dnsmasq.conf | sed "s/#INTERFACE#/$INTERFACE/" | sed "s/#FIRST_IP#/$FIRST_IP/" | sed "s/#LAST_IP#/$LAST_IP/" | sed "s/#RASPBERRY_IP#/$RASPBERRY_IP/" | sed "s/#DOMAIN#/$DOMAIN/"  > ./tmp/dnsmasq.conf

# Move configs
mv ./tmp/hostapd.conf /etc/hostapd/hostapd.conf
mv ./tmp/dhcpd.conf /etc/dhcpd.conf
mv ./tmp/dnsmasq.conf /etc/dnsmasq.conf

rm -r ./tmp

systemctl enable dnsmasq
systemctl enable hostapd
systemctl start dnsmasq
systemctl start hostapd


