#!/bin/bash

# Disconnect from NordVPN
nordvpn disconnect

# Change iptables
iptables -P FORWARD ACCEPT
iptables -P INPUT ACCEPT
iptables -F
iptables -t nat -F
