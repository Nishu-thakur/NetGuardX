#!/usr/bin/bash

###### Update and install necessary packages

if [ "$UID" -eq 0 ]; then
    echo "You are running as sudo ."
else
    echo "You are not root. Please run this script as root(sudo)."
    exit 1
fi

sudo apt update 
# DOWNLOAD IPTABLES
sudo apt-get install iptables -y
# DOWNLOAD psad
wget https://www.cipherdyne.org/psad/download/psad-2.4.6.tar.bz2
sudo mv psad-2.4.6.tar.bz2 /usr/local/src/
sudo tar xfj /usr/local/src/psad-2.4.6.tar.bz2
sudo /usr/local/src/psad-2.4.6/install.pl

# DOWNLOAD fwsnort
wget https://www.cipherdyne.org/fwsnort/download/fwsnort-1.6.8.tar.bz2
sudo mv fwsnort-1.6.8.tar.bz2 /usr/local/src/
sudo tar xfj /usr/local/src/fwsnort-1.6.8.tar.bz2
sudo /usr/local/src/fwsnort-1.6.8/install.pl

# DOWNLOAD rsyslog
if ! dpkg -l | grep -q rsyslog; then
    sudo apt-get install rsyslog
fi


perl -e 'print "#"x30,"\n"'
perl -e 'print "#"x5 ,"Mendatary Configuration", "#"x5,"\n"'

echo "\n*** OPEN CONFIGURATION FILE ***\n"
echo "[+] sudo nano /etc/psad/psad.conf"
echo "#:-EMAIL_TO \"your_email@example.com"
echo "#:-ENABLE_PERSISTENCE             Y"
echo "#:-IPT_SYSLOG_FILE                /var/log/syslog"
echo "#:-SYSLOG_DAEMON                  rsyslog"
echo "#:-ENABLE_AUTO_IDS                Y"
echo "#:-AUTO_IDS_DANGER_LEVEL          4"
echo "#:-ENABLE_AUTO_IDS_REGEX          Y"
echo "#:-IPTABLES_BLOCK_METHOD          Y"



