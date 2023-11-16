#!/bin/bash
if ! grep -R "batman-adv" /etc/modules
then
  echo 'batman-adv' | tee --append /etc/modules
fi
if ! grep -R "denyinterfaces wlan0" /etc/dhcpcd.conf
then
  echo 'denyinterfaces wlan0' | tee --append /etc/dhcpcd.conf
fi
if [ ! -f /etc/network/interfaces.d/bat0 ]
then
  cp /source/bat0 /etc/network/interfaces.d/
fi
if [ ! -f /etc/network/interfaces.d/wlan0 ]
then
 cp /source/wlan0 /etc/network/interfaces.d/
fi

# batman-adv interface to use
batctl if add wlan0
ifconfig bat0 mtu 1468

# Tell batman-adv this is a gateway client
#batctl gw_mode client

# Activates batman-adv interfaces
nsenter -t 1 -m -u -i -n ifconfig wlan0 up
nsenter -t 1 -m -u -i -n ifconfig bat0 up
iwconfig wlan0 essid iot-mesh

sleep infinity
