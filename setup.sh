#!/bin/bash
YELLOW='\033[1;33m'
RESET='\033[0m'

# Update package list and install necessary dependencies
sudo apt-get update
sudo apt-get install -y rsyslog iptables postfix

echo "${YELLOW}# INSTALL PSAD...${RESET}"
# Install PSAD from source
sudo apt-get install -y git make perl
git clone https://github.com/mrash/psad.git
cd psad
sudo ./install.pl --runlevel 2

echo "${YELLOW}# INSTALL FWSnort...${RESET}"
# Install FWSnort from source
cd ..
git clone https://github.com/mrash/fwsnort.git
cd fwsnort
sudo ./install.pl

# Enable services
sudo systemctl enable rsyslog
sudo systemctl enable psad

echo "${YELLOW}NetGuardX dependencies installed and services enabled!${RESET}"
