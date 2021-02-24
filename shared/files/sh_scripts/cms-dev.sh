#!/bin/bash
# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"



printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at '/vagrant_data/exports'${normal}\n"
. /vagrant_data/exports

# Bui
printf "${green_bold}[CREATING]${normal} - Container: ${red_bold}'${C1_NAME}'  ${normal}\n"
sudo lxc launch ubuntu:18.04 ${C1_NAME} --profile dev-prof > /dev/null 2>&1

printf "${green_bold}[SLEEPING]${normal} - Time: ${red_bold}10 Seconds${normal}\n"
sleep 10

# Documenting the IP of the Container

CMS_LXD_IP=$(sudo lxc list ${C1_NAME} -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
printf "${green_bold}[EXPORTING]${normal} - IP: ${red_bold} ${CMS_LXD_IP} Of the Container '${C1_NAME}' to ${EXPORTS}${normal}\n"
printf "\nCMS_IP=\"${CMS_LXD_IP}\"    # Added by cms-dev.sh Delete once provisioned" >> ${EXPORTS}


# Putting the exports in the machine
printf "${green_bold}[TRANSFERRING]${normal} - Files to: ${red_bold}${C1_NAME}${normal}\n"
sudo lxc file push --recursive ${C1_DIR}/ ${C1_NAME}/home/ubuntu/ > /dev/null 2>&1
sudo lxc file push ${EXPORTS} ${C1_NAME}/home/ubuntu/${C1_NAME}/ > /dev/null 2>&1


# Installing Python inside the container

printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CONFIGURING] CONTAINER 2 - ${C1_NAME} (PYTHON)${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[RUNNING]${normal}  - Shell Script: ${red_bold}'/home/ubuntu/cms-dev/python_install.sh (Inside Cont: ${C1_NAME}.sh)'${normal}\n"
sudo lxc exec cms-dev bash /home/ubuntu/cms-dev/python_install.sh


printf "${green_bold}[RUNNING]${normal}  - Shell Script: ${red_bold}'/home/ubuntu/cms-dev/djangocms_install.sh (Inside Cont: ${C1_NAME}.sh)'${normal}\n"
sudo lxc exec cms-dev bash /home/ubuntu/cms-dev/djangocms_install.sh
### CONTINUES HERE AFTER PYTHON INSTALL

printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at $EXPORTS${normal}\n"
. $EXPORTS

printf "${green_bold}[CLEANUP]${normal} - Deleting:${red_bold} CMS_IP Var at '${EXPORTS}'${normal}\n"
sudo sed -i '/^CMS_IP=/d' /vagrant_data/exports

printf "${green_bold}[RUNNING]${normal}  - Shell Script: ${red_bold}'/home/ubuntu/cms-dev/djangocms_start.sh (Inside Cont: ${C1_NAME}.sh)'${normal}\n"
sudo lxc exec cms-dev bash /home/ubuntu/cms-dev/djangocms_start.sh

## Server setup finishes at cms-dev/djangocms_start.sh
