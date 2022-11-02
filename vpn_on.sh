#!/bin/bash

# Get state of nordvpn settings
declare -A settingsarraya
while IFS= read -r a b; do
  key=$(echo "$line" | awk -F: '{print $1}')
	value=$(echo "$line" | awk -F: '{print $2}')
	echo $key:$value
	settingsarray["$key"]="$value"
done < <(nordvpn settings | awk -F: '/Technology/,/DNS/{print $1,$2}')

while IFS= read -r line1 <&3 && IFS= read -r line2 <&4; do
  settingsarray["$line1"]="$line2"
done 3< <(nordvpn settings | awk '/Whitelisted/{gsub(/:/,"");print $NF}') 4< <(nordvpn settings | awk '/Whitelisted/{getline;print $1;next}')

# Set up nordvpn rules
if [[ ${settingsarray[Technology]} != "NORDLYNX" ]]; then
	nordvpn set technology nordlynx
fi
nordvpn set dns off
nordvpn set killswitch off
nordvpn whitelist add port 22
nordvpn whitelist add "$(ip a | grep eth0 | awk '/inet/{print $2}' | sed 's:[^.]*$:0/24:')"

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

# Connect to NordVPN US Server
nordvpn connect us
