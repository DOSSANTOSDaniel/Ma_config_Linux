#!/bin/bash

sudo apt-get update

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
apt install snapd
sudo snap install core
sudo snap install snap-store

# Installation de Docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install apt-transport-https -y
sudo apt-get install ca-certificates -y
sudo apt-get install curl -y
sudo apt-get install gnupg -y
sudo apt-get install lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Applications snap
snap install -y arduino
snap install -y telegram-desktop
snap install -y ledger-live-desktop
snap install -y audible-for-linux
snap install -y code
snap install -y glow
snap install -y czkawka
snap install -y pycharm-community
snap install -y simplenote
snap install -y bitwarden
