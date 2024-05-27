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

# Security
alias rm='rm -i'
alias mv='mv -biv'
alias cp='cp -biv'

# Wake on lan
alias pveon='wol --ipaddr=192.168.x.255 xx:xx:xx:xx:xx:xx'
alias nexton='wol --ipaddr=192.168.x.255 xx:xx:xx:xx:xx:xx'

# Distrobox
alias ubuntu='distrobox-enter --name ubuntu --no-workdir'
alias alpine='distrobox-enter --name alpine --no-workdir'
alias kali='distrobox-enter --name kali --no-workdir'
alias arch='distrobox-enter --name arch --no-workdir'
alias alma='distrobox-enter --name alma --no-workdir'

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
  df -h -t btrfs -T /
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
echo "+----------------------------+----------------------+----------------------+"
echo
pong

