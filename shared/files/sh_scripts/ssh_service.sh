#!/bin/bash

# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

shopt -s expand_aliases

printf "${green_bold}[SOURCING]${normal}\t  - Sourcing: ${red_bold}Variables at '/vagrant_data/exports'${normal}\n"
. /vagrant_data/exports

printf "${green_bold}[CD]${normal} \t  - To: ${red_bold}'/vagrant_data/files/sh_scripts${normal}\n"
cd /vagrant_data/files/sh_scripts

printf "${green_bold}[COPYING]${normal}    - File: ${red_bold}'../configs/sshd_config' --> /etc/ssh/sshd_config${normal}\n"
sudo cp ../configs/sshd_config /etc/ssh/sshd_config

printf "${green_bold}[CREATING]${normal}   - Folder: ${red_bold}${SSH_AUTH_DIR}${normal}\n"
sudo mkdir ${SSH_AUTH_DIR}

printf "${green_bold}[COPYING]${normal}    - SSH Key: ${red_bold}'../others/${USER_ADM}.pub' --> ${SSH_AUTH_DIR}${USER_ADM}.pub${normal}\n"
sudo cp ../others/${USER_ADM}.pub ${SSH_AUTH_DIR}${USER_ADM}.pub

printf "${green_bold}[COPYING]${normal}    - SSH Key: ${red_bold}' /home/vagrant/.ssh/authorized_keys' --> ${SSH_AUTH_DIR}${USER_VAGRANT}.pub${normal}\n"
sudo cp /home/vagrant/.ssh/authorized_keys ${SSH_AUTH_DIR}${USER_VAGRANT}.pub

printf "${green_bold}[RESTARTING]${normal} - SSH Service: ${red_bold}'sudo systemctl restart sshd' ${normal}\n"
sudo systemctl restart sshd
# Sort permissions at the end.