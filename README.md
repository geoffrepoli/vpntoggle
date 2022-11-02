# Configuring a VPN Gateway over Ethernet Toggle with Alexa and NordVPN

#### WIP: 

## Part 1: Set up your Raspberry Pi
### 1.1. Set up Raspberry Pi Imager and format your SD/micro SD card as a boot drive
https://www.raspberrypi.com/software/
In my case, I have a Raspberry Pi 4 Model B and am running 64-bit Raspberry Pi OS Lite
### 1.2. Configure your OS
```
sudo raspi-config
```
It's important to a) change local account password to something secure, b) set locale, c) expand storage, d) enable auto-login.
### 1.3. Optional configuration
Perform any other optional settings/configurations you may want (such as key-based SSH,  aliases, etc.)
### 1.4. Update repos
```
sudo apt-get -y update && sudo apt-get -y upgrade
```
```
sudo apt-get dist-upgrade
```
### 1.5. Configure sysctl.conf
```
sudo mv /etc/sysctl.conf /etc/sysctl.conf_bak_$(date +%Y%m%d_%H%M%S)
```
```
sudo echo -e "\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1\nnet.ipv6.conf.tun0.disable_ipv6 = 1\n\n# Enable IP Routing\nnet.ipv4.ip_forward = 1" >> /etc/sysctl.conf
```
```
sudo sysctl -p
```
This will disable IPv6 (which might leak your location) and sets up forwarding rules for IPv4 so the Raspberry Pi can be used as a gateway for other network devices.

## Part 2: Setting up NordVPN
### 2.1 Install NordVPN commandline interface (CLI) client
### 2.2 Log in to NordVPN CLI
```
nordvpn login --token <your_generated_token>
```
You can generate a login token from your NordVPN account portal in the browser.

## Part 3: Setting up the VPN Toggle workflow
### 3.1 Create directory for VPN scripts to reside
```
sudo mkdir /opt/vpntoggle
```
Note that you don't have to use that path, you can choose a different one if you want.
### 3.2 Add the scripts named vpn_on.sh and vpn_off.sh in this repo to the directory created in 3.2
### 3.3 Make scripts executable
```
sudo chmod +x /opt/vpntoggle/*.sh
```

## Part 4: Preparing your network
### 4.1 Create a DHCP reservation
Log in to your router and find where you can set DHCP reservations for devices on your network, and add the Raspberry Pi. 
### 4.2 Turn off IPv6
If your ISP provides IPv6 addresses and you are able to disable this without any issues, go ahead and disable this. This can be done either from the modem's web console or the router's. This will reduce the potential for IPv6 leak.
### 4.2 Change your client Gateway
On each device that you want to use the VPN, manually change IP address of the gateway (also called Router depending on the device) to the internal IP address of the Raspberry Pi you reserved in 4.1 in that device's network settings
### 4.3 Change the client DNS Server
In the same network settings of each device, manually change the DNS Server(s) to point to NordVPN's DNS Servers:
```
103.86.96.100
103.86.99.100
```

## Part 5: Setting up TriggerCMD
### 5.1 Create a TriggerCMD account
https://www.triggercmd.com
### 5.2 Install TriggerCMD
```
sudo su -
```
```
apt -y install npm nodejs
```
```
wget https://agents.triggercmd.com/triggercmdagent_1.0.1_all.deb
```
```
dpkg -i triggercmdagent_1.0.1_all.deb
```
```
triggercmdagent
```
Paste your agent install token when prompted and hit ENTER. You can find your token here: https://www.triggercmd.com/user/computer/create
Now, kill the foreground service by pressing CTRL+C
```
/usr/share/triggercmdagent/app/src/installdaemon.sh
```
### 5.3 Edit triggers
```
sudo su -
```
```
mv /root/.TRIGGERcmdData/commands.json /root/.TRIGGERcmdData/commands.json_bak_$(date +%Y%m%d_%H%M%S)
```
Replace commands.json file with the one in this repo
```
systemctl restart triggercmdagent.service
```
### 5.4 Verify on TriggerCMD web
Ensure that your computer is listed at https://www.triggercmd.com/user/computer/list and the trigger you set is visible

## Part 6: Configuring Alexa
### 6.1 Get TriggerCMD Smart Home Skill
### 6.2 Perform device discovery


