# Configuring a VPN Gateway over Ethernet Toggle with Alexa and NordVPN

## Part 1: Set up your Raspberry Pi

### 1.1. Set up Raspberry Pi Imager and format your SD/micro SD card as a boot drive
https://www.raspberrypi.com/software/
In my case, I have a Raspberry Pi 4 Model B and am running 64-bit Raspberry Pi OS Lite
### 1.2. Configure your OS
Run `sudo raspi-config` and adjust settings. Important settings to configure:
a. Change log on password to something secure
b. Set locale
c. Expand storage
d. Configure auto-login
### 1.3. Optional configuration
Perform any other optional settings/configurations you may want (such as key-based SSH, etc.)
### 1.4. Update repos
Run `sudo apt-get -y update && sudo apt-get -y upgrade`
`sudo apt-get dist-upgrade`
### 1.5. Set up sysctl.conf
`sudo mv /etc/sysctl.conf /etc/sysctl.conf.bak`
```
sudo printf "%s\n" "# Disable IPv6" "net.ipv6.conf.all.disable_ipv6 = 1" \
"net.ipv6.conf.default.disable_ipv6 = 1" "net.ipv6.conf.lo.disable_ipv6 = 1" \
"net.ipv6.conf.tun0.disable_ipv6 = 1" "# Enable IP Routing" \
"net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
```

## Part 2: Setting up NordVPN

### 2.1 Install NordVPN client

### 2.2 Log in to NordVPN
nordvpn login --token <your_generated_token>

## Part 3: Setting up the VPN Toggle workflow
### 3.2 Create directory for VPN scripts to reside
In my case I went for /opt/vpntoggle. You can choose whichever
`sudo mkdir /opt/vpntoggle`
### 3.3 Add the scripts named vpn_on.sh and vpn_off.sh in this repo to the directory created above
### 3.4 Make scripts executable
`sudo chmod +x /opt/vpn/toggle/*.sh`

## Part 4: Preparing your network
### 4.1 Configure your network
### 4.2 Ensure RPi has a DHCP reservation on your router
### 4.3 Assign RPi a Static IP (optional if your router provides long DHCP reservations)
### 4.4 On the streaming device you wish to use the VPN gateway for, point it to the RPi's IP address for routing

## Part 5: Setting up TriggerCMD
### 5.1 Get TriggerCMD
### 5.2 Install TriggerCMD
`sudo su -`
`apt -y install npm nodejs`
`wget https://agents.triggercmd.com/triggercmdagent_1.0.1_all.deb`
`dpkg -i triggercmdagent_1.0.1_all.deb`
`triggercmdagent`
paste your agent install token when prompted. You can find your token here: https://www.triggercmd.com/user/computer/create
Kill the foreground service by pressing CTRL+C
`/usr/share/triggercmdagent/app/src/installdaemon.sh`
### 5.3 Edit triggers
`sudo su -`
`cd /root/.TRIGGERcmdData`
`mv ./commands.json ./commands.json.bak_$(date "%Y%m%d_%H%M%S)`
Replace *commands.json* file with the one in this repo
`systemctl restart triggercmdagent.service`
### 5.4 Verify on TriggerCMD web
Ensure that your computer is listed at https://www.triggercmd.com/user/computer/list and the trigger you set is visible

## Part 6: Configuring Alexa
### 6.1 Get TriggerCMD Smart Home Skill
### 6.2 Perform device discovery

