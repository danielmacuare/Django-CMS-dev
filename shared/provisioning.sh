#!/bin/bash

# ===================================================================
# provisioning.sh
# DESCRIPTION =======================================================
# Provisioning file for a DJANGO-CMS DEV Environment 
#  config.vm.box = "ubuntu/bionic64"   # https://app.vagrantup.com/ubuntu/boxes/bionic64
#  config.vm.box_version = "1.2.7" #
#
# AUTHOR ============================================================
# Daniel Alejandro Macuare Tombolini
# 2>&1 > /dev/null                     # Redirects stderr to stdout to only see errors and then redirects stdout to /dev/null to show nothing else.
# =================================================================== # Variables # ===================================================================
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"
VENV_NAME="py3e"
USER_DIR="/home/vagrant/"
EXPORTS="/vagrant_data/exports"
PYTHON_VERSION="3.8.2"
PYTHON_PCKS=(
        build-essential
        zlib1g-dev
        libncurses5-devlibgdbm-dev
        libnss3-dev
        libssl-dev
        libreadline-dev
        libffi-dev
        wget
)


# =================================================================== # Functions # ===================================================================
INST_PACK(){
for PCKGS in "$@"; do
        printf "$green_bold[INSTALLING]$normal - Packet: $red_bold$PCKGS$normal\n"
        sudo apt-get -qqy --no-install-recommends install $PCKGS > /dev/null 2>&1
done
}


# =================================================================== # Initial setup for Python # ===================================================================
# To avoid errror: dpkg-preconfigure: unable to re-open stdin: No such file or directory.
export DEBIAN_FRONTEND=noninteractive

printf "$normal\n\n############################################################################$normal\n"
printf "$normal\t\t[CONFIGURING] PYTHON $PYTHON_VERSION$normal\n"
printf "$normal############################################################################$normal\n"


# VENV
printf "$green_bold[SOURCING]$normal\t - Sourcing: $red_bold Exports at $EXPORTS$normal\n"
. $EXPORTS

printf "$green_bold[ADDING]$normal\t - Packet: $red_bold Virtualenv to the PATH$normal\n"
export PATH="$HOME/.local/bin:$PATH"

printf "$green_bold[INSTALLING]$normal\t - Packet: $red_bold Virtualenv $normal\n"
pip$PIP_VERSION install virtualenv

printf "$green_bold[CREATING]$normal\t\t - Packet: $red_bold Virtualenv Name: $VENV_NAME$normal\n"
virtualenv -p python$PIP_VERSION $USER_DIR$VENV_NAME/
cd $USER_DIR$VENV_NAME/
source bin/activate
printf "\n\n"
