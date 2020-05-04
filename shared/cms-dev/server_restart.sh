#!/bin/bash
# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

# THIS SCRIPT WAS JUST A TEXT, NOT IN USE
# This script will be executed on startup. Its purpose is to check if the CMS-DEV has booted via LXD
# If the container has booed, then this will run a script to start the CMS-DEV Django server.

printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at '/vagrant_data/exports'${normal}\n"
. /vagrant_data/exports

CMS_LXD_IP=$(sudo lxc list ${C1_NAME} -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
for retries in {1..5}
do
    if [[ "$CMS_LXD_IP" != 10.* ]]
    then
        echo "The container ${C1_NAME} does not have an IP. Will retry for 60 seconds."
        printf "Retry Attempt: $retries - Next retry in 10 seconds\n"
        CMS_LXD_IP=$(sudo lxc list ${C1_NAME} -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
        sleep 10
    else
        echo "\${C1_NAME} Has booted with the IP: ${CMS_LXD_IP}"
        sudo lxc exec cms-dev bash /home/ubuntu/cms-dev/djangocms_config.sh
        break
    fi
done

# One approach is to add an @reboot cron task:

# Running crontab -e will allow you to edit your cron.
# Adding a line like this to it:

# @reboot /path/to/script