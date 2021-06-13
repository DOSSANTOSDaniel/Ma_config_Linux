#!/bin/bash
#-*- coding: UTF8 -*-

#--------------------------------------------------#
# Script_Name: ep_printer.sh	                               
#                                                   
# Author:  'dossantosjdf@gmail.com'                 
# Date: lun. 07 juin 2021 15:04:20                                             
# Version: 2.0                                      
# Bash_Version: 5.0.17(1)-release                                     
#--------------------------------------------------#
# Description:
# Ce script permet l'installation et la configuration
# de l'imprimante EPSON ET-3750.
#
# Liens de téléchargement:
#
# Les pilotes pour Linux
# http://download.ebz.epson.net/dsc/search/01/search/searchModuleFromResult
#
# L'application epsonscan2
# http://support.epson.net/linux/en/epsonscan2.php
#
# Les pilotes pour windows
# https://support.epson.net/setupnavi/?LG2=FR&OSC=WS&MKN=et-3750&PINF=setup#P_SWS
#
# Autre tutoriel 
# https://wnw1005.tistory.com/530
#
# Les applications:
#   1 - epson-printer-utility
#   2 - epsonscan2
#                                                   
# Options:                                          
#                                                   
# Usage: ./ep_printer.sh                                            
#                                                   
# Limits:                                           
#                                                   
# Licence:                                          
#--------------------------------------------------#

set -eu

### Includes ###

### Fonctions ###

### Global variables ###
readonly printer_ip='192.168.0.114'

### Main ###
trap "rm -rf epsonscan2-bundle-6.6.2.4.x86_64.deb" EXIT

if [[ $UID != '0' ]]
then
  echo "Merci d’exécuter le script en tant que root !"
  exit 1
fi

usermod -aG lpadmin daniel 

systemctl stop cups-browsed
systemctl disable cups-browsed
  
apt-get update
apt-get install lsb qt5-default -y

dpkg -i DEB/epson-inkjet-printer-escpr2_1.1.33-1lsb3.2_amd64.deb
dpkg -i DEB/epson-printer-utility_1.1.1-1lsb3.2_amd64.deb

tar xvf DEB/epsonscan2-bundle-6.6.2.4.x86_64.deb.tar.gz

bash epsonscan2-bundle-6.6.2.4.x86_64.deb/install.sh 

lpadmin -p EPSON -E -v socket://${printer_ip}:9100 -D "Epson ET-3750 Series" -L "Epson" -o printer-error-policy="retry-job" -u allow:all -m lsb/usr/epson-inkjet-printer-escpr2/Epson/Epson-ET-3750_Series-epson-inkjet-printer-escpr2.ppd.gz

# imprimante par defaut
lpadmin -d EPSON

reboot











