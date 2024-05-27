########## User config #########

# History format
export HISTTIMEFORMAT="%F %T  "

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

# Wake on lan
alias pveon='wol --ipaddr=192.168.x.255 xx:xx:xx:xx:xx:xx'
alias nexton='wol --ipaddr=192.168.x.255 xx:xx:xx:xx:xx:xx'

# Security
alias rm='rm -i'
alias mv='mv -biv'
alias cp='cp -biv'

### Functions ###

# Delete temporary files
del_temp() {
  mapfile -t files < <(find $HOME -type f -name "*~" ! -name ".*" -a ! -path "*/.*" 2> /dev/null)
  
  for i in "${files[@]}"
  do
    rm -i "$i"
  done
}

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


### Banner ###
banner
echo
echo "+----------------------------+----------------------+----------------------+"
echo "|         Alias              |     Fonctions        |       Scripts        |"
echo "+----------------------------+----------------------+----------------------+"
echo "| maj     ---> Upgrade       | logerr Show logs     |                      |"
echo "| pve1    ---> SSH           | pong    Network test |                      |"
echo "| hap     ---> SSH           | banner  Info sys     |                      |"
echo "| del_temp ---> rm files temp| pveon                |                      |"
echo "| next    ---> SSH           | nexton               |                      |"
echo "| clean   ---> clean all     |                      |                      |"
echo "+----------------------------+----------------------+----------------------+"
echo
pong
