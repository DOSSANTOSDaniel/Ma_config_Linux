#!/bin/bash

if [[ $EUID != '0' ]]
then
  echo "Executer le script en tant que root !"
  exit 1
fi

apt-get update
apt full-upgrade -y

apt-get install vlc -y
apt-get install filezilla filezilla-common -y
apt-get install gedit -y
apt-get install gparted -y
apt-get install diodon -y
apt-get install terminator -y
apt-get install nmap -y
apt-get install tree -y
apt-get install screen -y
apt-get install vim -y
apt-get install ncdu -y
apt-get install wakeonlan -y
apt-get install htop -y
apt-get install git -y
apt-get install ghostwriter -y
apt-get install figlet -y
apt-get install anydesk -y
apt-get install curl -y
apt-get install anki -y
apt-get install mu -y
apt-get install trash-cli -y
apt-get install openssh-server -y
apt-get install gparted -y
apt-get install nextcloud-desktop -y
apt-get install mdp -y

# Installation de snapd
apt-get install snapd -y
apt-get install gnome-software-plugin-snap -y
snap install core

# Installation de flatpak
apt-get install flatpak -y
apt-get install gnome-software-plugin-flatpak -y

# Installation de Docker
apt-get remove docker docker-engine docker.io containerd runc -y
apt-get install apt-transport-https -y
apt-get install ca-certificates -y
apt-get install curl -y
apt-get install gnupg -y
apt-get install lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y

# Applications snap
snap install arduino
snap install telegram-desktop
snap install ledger-live-desktop
snap install audible-for-linux
snap install code
snap install glow
snap install pycharm-community
snap install simplenote
snap install gimp

# Applications flatpak
flatpak install -y Minder

