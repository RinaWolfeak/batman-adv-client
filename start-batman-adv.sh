#!/bin/bash
nsenter -t 1 -m -u -i -n apt update -y 
nsenter -t 1 -m -u -i -n apt install -y batctl
if ! grep -R "batman-adv" /etc/modules
then
  echo 'batman-adv' | tee --append /etc/modules
fi
if ! grep -R "denyinterfaces wlan0" /etc/dhcpcd.conf
then
  echo 'denyinterfaces wlan0' | tee --append /etc/dhcpcd.conf
fi
if ! grep -R "leasetime 60" /etc/dhcpcd.conf
then
  echo 'leasetime 60' | tee --append /etc/dhcpcd.conf
fi
if ! grep -R "wireless-essid" /source/wlan0
then
echo "    wireless-essid $MESH_NAME" | tee --append /source/wlan0
fi
if [ ! -f /etc/network/interfaces.d/wlan0 ]
then
 cp /source/wlan0 /etc/network/interfaces.d/
fi
if ! grep -R "address" /source/bat0
then
echo "    address $BAT_IP" | tee --append /source/bat0
fi
if [ ! -f /etc/network/interfaces.d/bat0 ]
then
 cp /source/bat0 /etc/network/interfaces.d/
fi

# batman-adv interface to use
batctl if add wlan0
ifconfig bat0 mtu 1468

# Tell batman-adv this is a gateway client
nsenter -t 1 -m -u -i -n batctl gw_mode client 3

# Activates batman-adv interfaces
ifconfig wlan0 up
ifconfig bat0 up
ifconfig bat0 $BAT_IP
nsenter -t 1 -m -u -i -n service dhcpcd restart
nsenter -t 1 -m -u -i -n service networking restart
nsenter -t 1 -m -u -i -n ifdown wlan0
nsenter -t 1 -m -u -i -n ifup wlan0
sleep infinity
