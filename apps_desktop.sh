#!/bin/bash

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
apt-get install figlet
apt-get install anydesk
apt-get install curl
apt-get install anki
apt-get install mu
apt-get trash-cli
apt-get openssh-server

apt-get install snap -y

imprimante scan
ventoy
gparted
client nextcloud

md

# Installation de Docker
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

 sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
     
     echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  sudo apt-get update

 sudo apt-get install docker-ce docker-ce-cli containerd.io


Snap
-----
snap install arduino
telegram-desktop
ledger-live-desktop
audible-for-linux
code
glow
czkawka
pycharm-community
simplenote
snap search bitwarden

server
-------
apt-get install htop
apt-get install tree -y
apt-get install screen -y
apt-get install vim -y
apt-get install nmap -y
apt-get install ncdu -y
