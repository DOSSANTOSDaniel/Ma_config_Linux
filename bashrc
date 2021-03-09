
################################################## 

### Alias perso ###
# SSH
alias oli='ssh -o "ServerAliveInterval 60" -X -p 2244 mangkone@87.88.200.33'
alias duino='ssh root@192.168.0.111'
alias pve1='ssh root@192.168.0.21'
alias omv='ssh root@192.168.0.121'
alias rasp='ssh -p 2022 daniel@192.168.0.113'
alias next='ssh daniel@192.168.0.112'

# Wake on lan
alias pveon='wakeonlan e8:40:f2:d6:71:8c'

# Update
alias maj='sudo apt update && sudo apt full-upgrade --allow-downgrades -y && sudo apt autoremove --purge -y && sudo apt autoclean && sudo snap refresh && sudo flatpak update -y && echo -e "\n MAJ OK ! \n"'

# Secu
alias rm='rm -i'
alias mv='mv -b'
alias cp='cp -b'


### Functions perso ###
cpoli() {
  rsync -avrz -e 'ssh -p 2244' --progress --partial --stats ${1} mangkone@87.88.200.33:/home/mangkone
}

olicp() {
  rsync -avrz -e 'ssh -p 2244' --progress --partial --stats mangkone@87.88.200.33:/home/mangkone/${1} /home/daniel/
}

pong() {
  if [[ $(ping -c 1 google.fr) ]]
  then
    echo -e "\t\t\t\t !¡! Ping OK !¡! \n"
  else
    if [[ $(ping -c 1 8.8.8.8) ]]
    then
      echo -e "\t\t\t\t !¡!¡!¡!¡ << Erreur: DNS >> !¡!¡!¡!¡ \n"
    else
      echo -e "\t\t\t\t !¡!¡!¡!¡ << Erreur: Connexion Internet ADSL >> !¡!¡!¡!¡ \n"
    fi
  fi
}

banner() {
  echo -e "\n"
  echo -e "\t\t\t\t $(/bin/date)"
  echo
  echo "Login: $(logname)"
  echo
  echo "Host: $(hostname)"
  echo
  echo "IP: $(hostname -I)"
  echo
  echo "Kernel: $(cat /proc/sys/kernel/osrelease)"
  echo
  uptime | cut -d " " -f10-15
  echo
  df -h -t ext4
}


### Prompt perso ###
PS0='\n'
PS1='\
\[\033[1;31m\][\
\[\033[32m\]\u\
\[\033[36m\]🐧\
\[\033[34m\]\h\
\[\033[1;31m\]]\
\[\033[1;33m\](\w)\$ '


### Banner perso ###
banner
echo
echo "+-------------------------+----------------------+"
echo "|         Alias           |     Fonctions        |"
echo "+-------------------------+----------------------+"
echo "| maj    ---> Mise à jour | cpoli [File_dan] D>O |"
echo "| oli    ---> SSH         | olicp [File_oli] D<O |"
echo "| pve1   ---> SSH         +----------------------+"
echo "| omv    ---> SSH         |"
echo "| duino  ---> SSH         |"
echo "| rasp   ---> SSH         |"
echo "| next   ---> SSH         |"
echo "| pveon  ---> Wake On Lan |"
echo "+-------------------------+"
echo
pong
