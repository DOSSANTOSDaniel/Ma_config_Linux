########## User config #########

# History format
export HISTTIMEFORMAT="%F %T  "

### Alias ###

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

### Banner ###
banner
echo
echo "+----------------------------+----------------------+-----------------------------------+"
echo "|         Alias              |     Fonctions        |       Scripts                     |"
echo "+----------------------------+----------------------+-----------------------------------+"
echo "| upnext   ---> Upgrade      | logerr Show logs     |scpt_scan.sh -> Scan               |"
echo "| del_temp ---> rm files temp|                      |scpt_backup.sh -> Sauvegarde -> PVE|"
echo "+----------------------------+----------------------+-----------------------------------+"
echo
pong