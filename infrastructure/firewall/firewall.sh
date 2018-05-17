#!/bin/sh

IPT="/sbin/iptables"
INET_INTERFACE="ens160"
VPN_INTERFACE="lxd-cluster-02"
VPN_NETWORK="10.250.0.0/24"

# Clean all tables
# Set default rules
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X

/etc/init.d/fail2ban restart
# All Drop by Design
$IPT -P OUTPUT ACCEPT
$IPT -P INPUT DROP
$IPT -P FORWARD DROP

# Allow localnetwork
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A FORWARD -o lo -j ACCEPT

# Curent connections
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Enable SSH from External Interface
$IPT -A INPUT -i $INET_INTERFACE  -p tcp --dport 22 -j ACCEPT

# Allow all from VPN network
$IPT -A INPUT -i $VPN_INTERFACE -j ACCEPT

# Nginx for web sites
$IPT -A INPUT -i $INET_INTERFACE  -p tcp --dport 80 -j ACCEPT
$IPT -A INPUT -i $INET_INTERFACE  -p tcp --dport 443 -j ACCEPT

# Enable NAT from Virtual Network
$IPT -A FORWARD -s $VPN_NETWORK -j ACCEPT
$IPT -A FORWARD -d $VPN_NETWORK -j ACCEPT
$IPT -t nat -A POSTROUTING -o $INET_INTERFACE -j MASQUERADE

# PortForwarding to VPN-Servers
/etc/port-forwarding.sh


exit 0