#!/usr/bin/env bash

SSID="NLocker"
PASSWORD="haslo123"
PORT=80
SSL_ENABLED=1

if [[ $EUID -ne 0 ]]; then
	echo "Run this script as root"
	exit
fi

installation_path="$1"
if [ -z "$installation_path" ]; then
	echo "Pass installation path as first argument"
	exit
fi

mkdir -p "$installation_path"


# Install packages
# apt install -y dnsmasq hostapd
# python3 -m pip install flask pyopenssl


