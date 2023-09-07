#!/bin/bash
# batman-adv interface to use
batctl if add wlan0
ifconfig bat0 mtu 1468

# Tell batman-adv this is a gateway client
batctl gw_mode client

# Activates batman-adv interfaces
ifconfig wlan0 up
ifconfig bat0 up