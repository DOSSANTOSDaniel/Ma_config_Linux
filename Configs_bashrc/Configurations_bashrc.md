# Fichier bashrc

## Alias
```bash
# Security
alias rm='rm -i'
alias mv='mv -biv'
alias cp='cp -biv'
```

### Connexions SSH
```bash
ssh_conn() {
  ssh_port="$1"
  ssh_user="$2"
  ssh_ip="$3"

  ssh -p $ssh_port ${ssh_user}@${ssh_ip}
}

### Alias ###
alias pve="ssh_conn '22' 'root' '192.168.x.xx'"
alias hap="ssh_conn 'XXXX' 'daniel' '192.168.x.xx'"
alias next="ssh_conn '22' 'daniel' '192.168.x.xxx'"
```

### Wake on lan
```bash
### Alias ###
# Wake on lan
alias pveon='wol --ipaddr=192.168.1.255 xx:xx:xx:xx:xx:xx'
alias nexton='wol --ipaddr=192.168.1.255 xx:xx:xx:xx:xx:xx'
# ou
alias pveon='wakeonlan -i 192.168.1.255 xx:xx:xx:xx:xx:xx'
alias nexton='wakeonlan -i 192.168.1.255 xx:xx:xx:xx:xx:xx'
```

## Bannière
```bash
banner() {
  echo -e "\n"
  echo "$(date +%F\ %R)"
  echo
  echo "IP: $(hostname -I)"
  echo
  uptime | cut -d " " -f10-15
  echo
  df -h -t ext4 -T /
  # df -h -t btrfs -T /
}

### Banner ###
banner
echo
echo "+----------------------------+----------------------+----------------------+"
echo "|         Alias              |     Fonctions        |       Scripts        |"
echo "+----------------------------+----------------------+----------------------+"
echo "|                            |                      |                      |"
echo "|                            |                      |                      |"
echo "+----------------------------+----------------------+----------------------+"
echo
```

## Supprimer des fichiers
```bash
# Delete temporary files
del_temp() {
  mapfile -t files < <(find $HOME -type f -name "*~" ! -name ".*" -a ! -path "*/.*" 2> /dev/null)
  
  for i in "${files[@]}"
  do
    rm -i "$i"
  done
}
```

## La fonction pong
```bash
pong() {
  default_gateway="$(ip route show default | awk '{print $3}')"
  dns_srv_ip="8.8.8.8"
  dns_srv_domain="google.fr"

  if ping -q -c 1 $dns_srv_ip > /dev/null 2>&1
  then
    echo "Ping OK !"
    if ping -q -c 1 $dns_srv_domain > /dev/null 2>&1
    then
      echo "DNS OK !"
    else
      echo "Error: DNS !"
      if ping -q -c 1 $default_gateway > /dev/null 2>&1
      then
        echo "Route $default_gateway OK !"
      else
        echo "Error: route $default_gateway !"
      fi
    fi
  else
    echo "Error: Network connection WAN"
    if ping -q -c 1 $default_gateway > /dev/null 2>&1
    then
      echo "Route $default_gateway OK !"
    else
      echo "Error: route $default_gateway !"
    fi
  fi
}
```

## Configuration de l'historique des commandes
```bash
export HISTTIMEFORMAT="%F %T  "
```

## Les logs
```bash
logerr() {
  local times="$(date +%F_%H-%M-%S)"
  local name_log_file="Log_${times}.log"
  local cur_dir="$(pwd)"
  local date_option='minutes' #minutes, hours, days, weeks, months, years
  local number_of='20'

  (
    echo -e "\n *---- Fichier LOG du $(date) ----*"
    echo -e "------------------------------------------------------------ \n"
    echo -e "\n *---- LOGS_LEVELS_Emergency ----* \n"
    sudo journalctl --no-pager --since "$number_of $date_option ago" -p 0
    echo -e "\n *---- LOGS_LEVELS_Alert ----* \n"
    sudo journalctl  --no-pager --since "$number_of $date_option ago" -p 1
    echo -e "\n *---- LOGS_LEVELS_Critical ----* \n"
    sudo journalctl  --no-pager --since "$number_of $date_option ago" -p 2
    echo -e "\n *---- LOGS_LEVELS_Error ----* \n"
    sudo journalctl  --no-pager --since "$number_of $date_option ago" -p 3
    echo -e "\n *---- LOGS_LEVELS_Warning ----* \n"
    sudo journalctl  --no-pager --since "$number_of $date_option ago" -p 4
  ) > $name_log_file

  if [ -f ${cur_dir}/${name_log_file} ]
  then
    echo -e "\n Fin de la création du fichier de log : ${cur_dir}/${name_log_file} \n"
  else
    echo "Erreur de la création du fichier de logs !"
  fi
}
```

## La comfiguration du prompt
```bash
### Prompt ###
if [ "$EUID" -eq 0 ]
then
  hostname_color='\[\033[1;31m\]'
  user_color='\[\033[1;31m\]'
  symbol=💀
  brackets_color='\[\033[32m\]'
  dir_color='\[\033[1;33m\]'
else
  hostname_color='\[\033[34m\]'
  user_color='\[\033[32m\]'
  symbol=👾                              #🐧
  brackets_color='\[\033[1;31m\]'
  dir_color='\[\033[1;33m\]'
fi

PS0='\n'
PS1='\n'\
${brackets_color}'┌──['\
${user_color}'\u'\
${symbol}\
${hostname_color}'\h'\
${brackets_color}']-('\
${dir_color}'\w'\
${brackets_color}')'\
'\n'${brackets_color}'│'\
'\n'${brackets_color}'└─'\
${dir_color}'\$ '
```

## Mise à jour

### ARCHLINUX
```bash
# Update system

maj() {
  echo -e "\n Mise à jour Pacman "  
  echo -e "------------------------\n"
  echo '------ Remove gnupg key ------'
  sudo rm -rf /etc/pacman.d/gnupg
  echo '------ Init gnupg key ------'
  sudo pacman-key --init
  echo '------ Populate gnupg key ------'
  sudo pacman-key --populate
  echo '------ ArchLinux keys ------'
  sudo pacman -Sy archlinux-keyring --noconfirm
  echo '------ Upgrade ------'
  sudo pacman -Suyy --noconfirm
  
  echo -e "\n Update SNAP "
  echo -e "------------------------\n"
  snap refresh --list
  snap refresh
  snap changes  
  
  echo -e "\n Update FLATPAK "
  echo -e "------------------------\n"
  flatpak update -y

  echo -e "\n Clean PACMAN "
  echo -e "------------------------\n"
  sudo pacman --sync --clean --noconfirm
  sudo pacman --remove --nosave --recursive --unneeded $(sudo pacman --query --quiet --deps) --noconfirm
 
  echo -e "\n Clean SNAP "
  echo -e "------------------------\n"
  snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
  snap changes

  echo -e "\n Clean FLATPAK "
  echo -e "------------------------\n"
  flatpak uninstall --unused
}
```

### FEDORA 
```bash
# Update system
maj() {
  echo -e "\n Début de la mise à jour ! \n"

  echo -e "Update DNF \n"
  sudo dnf upgrade --best --allowerasing --refresh --assumeyes  
  
  echo -e "\n Update SNAP \n"
  sudo snap refresh --list
  sudo snap refresh
  sudo snap changes

  echo -e "\n Update FLATPAK \n"
  sudo flatpak update -y
  #sudo flatpak repair 

  echo -e "\n Clean DNF \n"
  sudo dnf clean all --assumeyes 
  #sudo dnf remove $(sudo dnf repoquery --unsatisfied --quiet) --assumeyes 
  sudo dnf autoremove --assumeyes 
  if [[ $(sudo grep "^installonly_limit=" /etc/dnf/dnf.conf | cut -d '=' -f2) == '2' ]]
  then
    sudo dnf remove --oldinstallonly --assumeyes 2> /dev/null 
  else
    sudo sed -i '/^installonly_limit/s/=./=2/g' /etc/dnf/dnf.conf
    sudo dnf remove --oldinstallonly --assumeyes 2> /dev/null 
  fi
  
  echo -e "\n Clean SNAP \n"
  sudo snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
  sudo snap changes  
  
  echo -e "\n Clean FLATPAK \n"
  #flatpak uninstall --unused --assumeyes 
  sudo flatpak remove --unused --assumeyes 
}
```

### DEBIAN
```bash
# Update system
maj() {
  echo -e "\n Début de la mise à jour ! \n"
  
  echo -e "Update APT \n"
  sudo apt-get update
  sudo apt-get full-upgrade --allow-downgrades -y || sudo apt-get -f -y install
  
  echo -e "\n Update SNAP \n"
  sudo snap refresh --list
  sudo snap refresh
  sudo snap changes
  
  echo -e "\n Clean APT \n"
  sudo apt-get autoremove --purge -y
  sudo apt-get autoclean
  sudo apt-get clean
  [[ $(dpkg -l | grep ^rc) ]] && sudo dpkg -P $(dpkg -l | awk '/^rc/{print $2}') || echo 'Aucun résidu trouvé.'  
  
  echo -e "\n Clean SNAP \n"
  sudo snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
  sudo snap changes
}
```

### PROXMOX
```bash
# Update system
maj_pve() {
  pveupgrade
  echo -e "\n MAJ de la DB des templates de containers \n"
  pveam update
}
```