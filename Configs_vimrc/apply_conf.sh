#!/bin/bash
#-*- coding: UTF8 -*-

#************************************************#
# Nom:     apply_conf.sh                                      
# Auteur:  Daniel dossantosjdf@gmail.com         #
# Date:    15/03/2021                                      
# Version: 1.0                                   #
#                                                
# Rôle:    Customisation de .bashrc et .vimrc.   #
# Usage:   ./apply_conf.sh                                      
# Limites:                                       #
# Contraintes:                                   
# Licence:                                       #
#************************************************#

trap cleanup ERR
### Includes ###

### Fonctions ###
function cleanup()
{   
  for i in ${dir}
  do
    if [[ -f ${i}.save ]]
    then
       cp --backup=numbered ${i}.save ${i}
    fi
  done

   mv $(pwd)/.vimrc $(pwd)/config_vimrc
}

### Variables ###
user=$(cat /etc/passwd | grep 1000 | cut -d: -f1)
dir="/home/${user}/.vimrc /root/.vimrc"

### Main ###
if [[ ${LOGNAME} != "root" ]]
then
  echo -e "\n Merci d'exècuter le script avec l'utilisateur root ! \n"
  exit 1
fi

if [[ -f $(pwd)/.vimrc ]]
then
  echo -e "\n Le script a déjà été exècuté, merci de recloner le repo! \n"
  exit 1
fi

for i in ${dir}
do
  if [[ -f ${i} ]]
  then
     cp --backup=numbered ${i} ${i}.save
  fi
done

if ( apt-get install vim -y)
then 
   mkdir -p {/home/${user}/.vim,/root/.vim}/{backups,undo}
   mv $(pwd)/config_vimrc $(pwd)/.vimrc 
    
   cp --backup=numbered $(pwd)/.vimrc /root/
   cp --backup=numbered $(pwd)/.vimrc /home/${user}/
else
  echo "Impossible d’installer VIM !"
  exit 1
fi