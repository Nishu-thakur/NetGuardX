#!/usr/bin/bash

IPTABLES=/sbin/iptables
MODPROBE=/sbin/modprobe
INT_NET=192.168.43.0/24		

### flush existing rules and set chain policy setting to DROP
echo "[+] Flushing existing iptables rules..."

$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP

### load connection - tracking modules 
$MODPROBE ip_conntrack
$MODPROBE iptable_nat
$MODPROBE ip_conntrack_ftp
$MODPROBE ip_nat_ftp

##### Input Chain #####

echo "[+] Setting up INPUT Chain..."
### State Tracking rules 

$IPTABLES -A INPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-option --log-tcp-option
$IPTABLES -A INPUT -m state --state INVALID -j DROP
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### anti-spoofing rules

$IPTABLES -A INPUT -i eth0 ! -s $INT_NET -j LOG --log-prefix "SPOOFED PKT "
$IPTABLES -A INPUT -i eth0 ! -s $INT_NET -j DROP

### ACCEPT rules 

$IPTABLES -A INPUT -i eth0 -p tcp -s $INT_NET --dport 22 --syn -m state --state NEW -j ACCEPT

$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

### default INPUT LOG rule

$IPTABLES -A INPUT ! -i lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options


###### OUTPUT Chain ##########

echo "[+] Setting up OUTPUT chain..."
### state tracking rules 

$IPTABLES -A OUTPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options

$IPTABLES -A OUTPUT -m state --state INVALID -j DROP
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### ACCEPT rules for allowing connections out

$IPTABLES -A OUTPUT -p tcp --dport 21 --syn -m state --state NEW -j ACCEPT 
$IPTABLES -A OUTPUT -p tcp --dport 22 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 25 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 43 --syn -m state --state NEW -j ACCEPT 
$IPTABLES -A OUTPUT -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 443 --syn -m state --state NEW -j ACCEPT 
$IPTABLES -A OUTPUT -p tcp --dport 23 --syn -m state --state NEW -j ACCEPT 
$IPTABLES -A OUTPUT -p tcp --dport 4321 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 53 -m state --state NEW -j ACCEPT 

### Defualt OUTPUT LOG rule

$IPTABLES -A OUTPUT ! -o lo -j LOG  --log-prefix "DROP " --log-ip-options --log-tcp-options


########## FORWARD chain ###########
echo "[+] Setting up FORWARD chain..."
### STATE tracking rules 

$IPTABLES -A FORWARD -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
$IPTABLES -A FORWARD -m state --state INVALID -j DROP
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

### ANTI spoofing rules 

$IPTABLES -A FORWARD -i eth0 ! -s $INT_NET -j LOG --log-prefix "SPOOFED PKT " 
$IPTABLES -A FORWARD -i eth0 ! -s $INT_NET -j DROP

### ACCEPT rules

for port in $(echo 21 22 25 43 80 443);do
	$IPTABLES -A FORWARD -p tcp --dport $port --syn -m state --state NEW -j ACCEPT
done 

$IPTABLES -A FORWARD -p tcp -i eth0 -s $INT_NET --dport 4321 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p udp --dport  53 -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type echo-request -j ACCEPT

### default log rule
$IPTABLES -A FORWARD ! -i lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options
