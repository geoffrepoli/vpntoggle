#!/bin/bash

# Disconnect
nordvpn disconnect

# Clear iptables rules
iptables -P FORWARD ACCEPT
iptables -P INPUT ACCEPT
iptables -F
iptables -t nat -F
