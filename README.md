# kali-linux-private-network-setup
follow my Steps on how to set up kali linux to be a private and encrypted server for your homes/businesses Network

hello welcome, Please follow my Steps on how to set up kali linux to be a private and encrypted server for your homes/businesses Network. (auto macchange, dns server setup and network vpn)

DEPENDENCIES NEEDED: (make sure you have the right pkgs for each one)

sudo apt install bind9

sudo apt install macchanger

sudo apt install ufw 

first please make sure Everything is up to date with:

sudo apt update && sudo apt full-upgrade && sudo apt auto-remove

now lets get started on building your private network server.

AUTO MACCHANGE:

open your terminal and check your current mac address with ifconfig.

after please follow these steps to set up auto macchange (you'll have to get the file path to macchange.sh after creating the shell script)

open an empty nano file then write this script in please make sure you choose the right network interface remember to use ifconfig to get the network interface you are using.

SCRIPT:

#!/bin/bash
# Replace "interface_name" with your network interface name
interface_name="wlan0"

# Disable the network interface
sudo ifconfig $interface_name down

# Change the MAC address to a random address
sudo macchanger -r $interface_name

# Re-enable the network interface
sudo ifconfig $interface_name up

next make the shell script executable with 

chmod +x macchange.sh

now we need to set up a cron job to automate this

first open your crontab for editing with

sudo crontab -e

this will open the crontab in your default text editor. 

add this at the bottom of the file (remember to change the path to your macchange.sh file)

# Replace "0 2 * * *" with your desired schedule (this runs the script at 2 AM every day)
0 2 * * * /path/to/your/macchange.sh 

In the above line, "0 2 * * *" represents the schedule. change the 2 to the time you want the macchange to take place

now save and exit to complete the auto macchange.

DNS server: 

first we must make changes to the bind9 config files with.

sudo nano /etc/bind/named.conf.options

change where it says 0.0.0.0 to 9.9.9.9 this is qaud9 DNS address do not be stupid and use googles or cloudflares.

after save the file 

now you need to open a different one for the Forward address look in the bind9 files to get the name for each db file and add each one to the end of this cmd there is around 5-6

sudo nano /etc/bind/db

in each file you open please change the serial number to 0

now its time to start the dns server, if its not named it will be bind9 sometimes kali will change the name for bind9 to named (dont know why they just do)

sudo systemctl restart named

check the status with 

sudo system named after input ctrl c 

now we need to bind it to firewall with 

sudo ufw enable 

sudo ufw allow named

now check the status of the firewall with

sudo ufw status 

if it says bind9 allow you have successfully set up the dns server.

VPN SERVER: 

first install the file for OpenVPN software with

wget https://git.io/vpn -O openvpn-install.sh

now give permission to run this cmd with 

chmod +x openvpn-install.sh

now run this script with 

sudo ./openvpn-install.sh

now the script will ask for your public ip address if it does not do it automatically please put it in manually with 

curl -s http://tnx.nl/ip

now we need to choose the connection type it does reccomend UDP so use it in my opinion 

now select the port to use for listening for OpenVPN

now you need to choose the DNS to use with the vpn server please select number 1 as we set up the DNS earlier with bind9 

now type a name for the client certificate you can use any name you like 

now you have everything set up to run the OpenVPN server press enter to configure the OpenVPN server this may take time depending on your kali system 

after the process is completed our OpenVPN server should now be configured and running

use the kali.ovpn config file to connect your devices  to the VPN server in your network.

check your OpenVPN server status with 

sudo service openvpn-server@server status

you should see the server is setup and running 
the server should start automatically on every boot up to manually disable it use 

sudo service openvpn-server@server stop

to manually start it use 

sudo service openvpn-server@server start

you can connect your VPN over internet this means when we are out of our local network we can still connect to our server To do this we need port forwarding and a static IP. First of all we fix our local IP from the wifi settings IPV4 tab in network configuration settings.

forward your 1194 port (Default port for OpenVPN) in UDP, from your router's settings. Then set up your static ip you will need a static public IP. Usually you get a dynamic IP from your internet service provider. so you either ask them to provide a static IP or you can use some tool like noip.

now we can conmect to our VPN server from anywhere.

you need the OpenVPN file in the connecting device. OpenVPN client is available for almost every major operating system for free. you can run the ovpn file using OpenVPN software in Windows, Mac, Linux, Android, iOS etc.

AND THAT MY FRIENDS IS HOW TO SET UP KALI LINUX AS A PRIVATE SERVER FOR YOUR HOME NETWORK (macchange should automate the mac change on your network for the time you set it, bind9 will route your network through the private dns server we set bypassing your network firewall, and the OpenVPN server will output a connection for all your devices to connect to to be able to stay private encrypted from anywhere you are in the world)

enjoy

-ZłO
