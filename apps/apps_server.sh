#!/bin/bash

if [[ $EUID != '0' ]]
then
  echo "Executer le script en tant que root !"
  exit 1
fi

apt-get update

apt-get install nmap -y
apt-get install tree -y
apt-get install screen -y
apt-get install vim -y
apt-get install ncdu -y
apt-get install htop -y
apt-get install git -y
apt-get install curl -y
apt-get install trash-cli -y
apt-get install openssh-server -y
