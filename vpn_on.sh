#!/bin/bash

# Set up nordvpn rules
nordvpn set technology nordlynx
nordvpn set dns 1.1.1.1 1.0.0.1
nordvpn set killswitch off
nordvpn whitelist add port 22

# Set up iptables rules
iptables -t nat -A POSTROUTING -o nordlynx -j MASQUERADE
iptables -A FORWARD -i eth0 -o nordlynx -j ACCEPT
iptables -A FORWARD -i nordlynx -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth0 -p icmp -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P FORWARD DROP
iptables -P INPUT DROP

# Connect
nordvpn connect us
