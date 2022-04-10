# raspberry_wifi
WiFi configuration tool for RaspberryPi

## Overview
At first, raspberryPi works in AP (access point) mode. User connects with the AP with correct credentials. Then, the user is able to send requests to API to get a list of other available access points. The user chooses an AP and sends an another request, giving SSID and password in the request's body. Finally, RaspberryPi reboots and works in station mode, being connnected to choosen network.

## Installation
```bash
$ git clone https://github.com/nmaszin/raspberry_wifi
$ cd raspberry_wifi
$ chmod +x install.sh
$ ./install.sh
```

To uninstall, execute the following command:
```bash
$ ./uninstall.sh
```

All available configuration is available at the beginning of install.sh file
