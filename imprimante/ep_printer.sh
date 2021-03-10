#!/bin/bash

#************************************************#
# Nom:     ep_printer.sh                         #
# Auteur:  daniel <daniel.massy91@gmail.com>     #
# Date:    10/03/2021                            #
# Version: 1.0                                   #
#                                                #
# Rôle:    Installe et configure ET-3750.        #
# Usage:   # ./ep_printer.sh                     #
#                                                #
# Documentation :                                #
#  http://download.ebz.epson.net/man_j/linux/    #  
#  http://download.ebz.epson.net/dsc/search/01/  #
#search/searchModuleFromResult                   #
#                                                #
#  http://support.epson.net/linux/src/           #
#  saisir "ET-3750"                              #
#************************************************#

### Fonctions ###
deb_install() {
  apt-get install lsb
  apt install printer-driver-escpr

  apt-get install qt5-default
  apt-get install qtbase5-dev 

  dpkg -i RPM/epson-inkjet-printer-escpr2_1.1.28-1lsb3.2_amd64.deb
  dpkg -i RPM/epson-printer-utility_1.1.1-1lsb3.2_amd64.deb

  tar xvf RPM/epsonscan2-bundle-6.6.2.3.x86_64.deb.tar.gz 

  ./epsonscan2-bundle-6.6.2.3.x86_64.deb/install.sh 
}

rpm_install() {
  dnf install lsb
  dnf install gutenprint-cups

  dnf install qt5-qtbase 
  dnf install qt5-qtbase-devel

  rpm -U RPM/epson-inkjet-printer-escpr2-1.1.28-1lsb3.2.x86_64.rpm 
  rpm -U RPM/epson-printer-utility-1.1.1-1lsb3.2.x86_64.rpm

  tar xvf RPM/epsonscan2-bundle-6.6.2.3.x86_64.rpm.tar.gz

  ./epsonscan2-bundle-6.6.2.3.x86_64.rpm/install.sh
}

if [[ ${LOGNAME} != "root" ]]
then
  echo "Merci d’exécuter le script en tant que root !"
  exit 1
fi

if [[ $(dpkg -s "apt" 2> /dev/null) || $(dpkg -s "apt-get" 2> /dev/null) ]]
then
  deb_install
elif [[ $(rpm -qi "dnf" 2> /dev/null) ]]
then
  rpm_install
else
  echo 'INFO : Gestionnaire de paquets non prit en charge'
  exit 1
fi

lpadmin -p EPSON -v socket://192.168.0.114:9100 -D "Epson ET-3750 Series" -L "Epson" -o printer-error-policy="retry-job" -u allow:all -m lsb/usr/epson-inkjet-printer-escpr2/Epson/Epson-ET-3750_Series-epson-inkjet-printer-escpr2.ppd.gz

cupsenable EPSON

sudo sed -i 's/No/Yes/g' /etc/cups/printers.conf

service cups restart











