#!/bin/bash

# Description:
#	Permet l'installation de mes applications
#----------------------------------------------------------------#
# Usage: ./app_kali_docker.sh
#	Exécuter le script en root!
#
# Auteurs:
#  	Daniel DOS SANTOS < daniel.massy91@gmail.com >
#----------------------------------------------------------------#

### Installation

# init
apt clean 
apt update 
apt upgrade -y 
apt full-upgrade -y

# variables
usertos="root"
versiontor=9.0.1

# installation de simplenote
wget https://github.com/Automattic/simplenote-electron/releases/download/v1.10.0/Simplenote-linux-1.10.0-amd64.deb
apt install gconf2 -y
dpkg -i Simplenote-linux-1.10.0-amd64.deb
sleep 1
rm Simplenote-linux-1.10.0-amd64.deb

# Installation de Wireshark
apt install wireshark -y
usermod -a -G wireshark "$usertos"
chgrp wireshark /usr/bin/dumpcap
chmod 771 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

# Installation de Visual Studio Code
wget http://packages.microsoft.com/repos/vscode/pool/main/c/code/code_1.40.1-1573664190_amd64.deb
apt install ./code_1.40.1-1573664190_amd64.deb -y
sleep 1
rm code_1.40.1-1573664190_amd64.deb
code --install-extension timonwong.shellcheck

# Install Katoolin
apt install git
git clone https://github.com/LionSec/katoolin.git 
cp katoolin/katoolin.py /usr/bin/katoolin
chmod +x /usr/bin/katoolin
rm -rf katoolin

# App de secu
apt install tor -y
service tor start
apt install htop -y 
apt install nethogs -y
apt install maltego -y
apt install metasploit-framework -y
apt install burpsuite -y
apt install aircrack-ng -y
apt install hydra -y
apt install nmap -y
apt install beef-xss -y
apt install nikto -y
apt install psmisc -y
apt install openvas -y
# Installation de tor
mkdir -p /root/Documents/TOR/
cd /root/Documents/TOR/
lynx -dump https://dist.torproject.org/torbrowser | sed "13 q"
# Téléchargement de tor
wget https://dist.torproject.org/torbrowser/"$versiontor"/tor-browser-linux64-"$versiontor"_fr.tar.xz   
# Extratction
tar xvf tor-browser-linux64*  
cd /root/Documents/TOR/tor-browser_fr/
# Création du raccourci
./start-tor-browser.desktop --register-app
# Bug root
if [ "$(id -u)" -eq 0 ]; then
           sed -i -e 's/-eq 0/-eq 1000/' /root/Documents/TOR/tor-browser_fr/Browser/start-tor-browser 
fi

rm -rf /root/Documents/TOR/*_fr.tar.xz

# Autres programmes
apt install vlc -y
apt install filezilla -y
apt install filezilla-common -y
apt install gdebi -y
apt install gedit -y
apt install gparted -y
apt install diodon -y
apt install keepassx -y
apt install remmina -y
apt install terminator -y
apt install nwipe -y
apt install lynx -y
apt install alsa-utils -y
apt install synaptic -y
apt install tree -y
apt install screen -y
apt install vim -y

# clean
apt autoremove --purge -y
apt autoclean
