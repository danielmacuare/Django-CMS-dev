#!/bin/bash
# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"



printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at '/vagrant_data/exports'${normal}\n"
. /vagrant_data/exports

# Bui
printf "${green_bold}[CREATING]${normal} - Container: ${red_bold}'${C2_NAME}'  ${normal}\n"
sudo lxc launch ubuntu:18.04 ${C2_NAME} --profile dev-prof > /dev/null 2>&1

# Launch a container
sudo lxc launch ubuntu:18.04 ${C2_NAME} --profile dev-prof > /dev/null 2>&1

printf "${green_bold}[SLEEPING]${normal} - Time: ${red_bold}10 Seconds${normal}\n"
sleep 10

# Documenting the IP of the Container

HAP_LXD_IP=$(sudo lxc list ${C2_NAME} -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
printf "${green_bold}[EXPORTING]${normal} - IP: ${red_bold} ${HAP_LXD_IP} Of the Container '${C2_NAME}' to ${EXPORTS}${normal}\n"
printf "\nHAP_LXD_IP=\"${HAP_LXD_IP}\"    # Added by haproxy-dev.sh Delete once provisioned" >> ${EXPORTS}


# Putting the exports in the machine
printf "${green_bold}[TRANSFERRING]${normal} - Files to: ${red_bold}${C2_NAME}${normal}\n"
sudo lxc file push --recursive ${C2_DIR}/ ${C2_NAME}/home/ubuntu/ > /dev/null 2>&1
sudo lxc file push ${EXPORTS} ${C2_NAME}/home/ubuntu/${C2_NAME}/ > /dev/null 2>&1

# Installing Python inside the container
printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CONFIGURING] CONTAINER 1 - ${C2_NAME} (PYTHON)${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[RUNNING]${normal}  - Shell Script: ${red_bold}'${HAP_SHARED_DIR}/python_install.sh (Inside Cont: ${C2_NAME}.sh)'${normal}\n"
sudo lxc exec ${C2_NAME} bash ${HAP_SHARED_DIR}/haproxy_install.sh


printf "${green_bold}[IPTABLES]${normal} - DNAT: ${red_bold}Traffic ---> Vagrant Box (enp0s3 tcp 80) ---> ${C2_NAME} ${HAP_LXD_IP}:8000${normal}\n"
sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80 -j DNAT --to-destination ${HAP_LXD_IP}:80
# To manually check and delete DNAT Rules 
# sudo iptables -L -t nat --line-number
# sudo iptables -t nat -D PREROUTING 1

# Installing Persistent iptables
printf "${green_bold}[INSTALLING]${normal} - IPTables: ${red_bold}apt get iptables-persitent${normal}\n"
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get -y install iptables-persistent > /dev/null 2>&1


printf "${green_bold}[CLEANUP]${normal} - Deleting:${red_bold} HAP_LXD_IP Var at '${EXPORTS}'${normal}\n"
sudo sed -i '/^HAP_LXD_IP=/d' ${EXPORTS}