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
VENV_NAME="venvs/py3e"
USER_DIR="/home/vagrant/"
EXPORTS="/vagrant_data/exports"
# For all available Python versions check here https://www.python.org/ftp/python/
PYTHON_VERSION="3.8.2"
PIP_VERSION="3.8"
PYTHON_PCKS=(
        build-essential
        zlib1g-dev
        libncurses5-dev
        libgdbm-dev
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

# Initial APT Update 
printf "$green_bold[UPDATING]$normal -$red_bold APT (This may take some minutes) $normal"
sudo apt-get -qqy update > /dev/null 2>&1
printf "\n"


printf "$normal\n\n############################################################################$normal\n"
printf "$normal\t\t[BUILDING] PYTHON $PYTHON_VERSION FROM SOURCE $normal\n"
printf "$normal############################################################################$normal\n"

INST_PACK "${PYTHON_PCKS[@]}"
printf "\n"


cd /usr/src
printf "$green_bold[DOWNLOADING]$normal - Downloading:$red_bold Python $PYTHON_VERSION$normal\n"
sudo wget -q -nv https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz

printf "$green_bold[EXTRACTING]$normal  - Extracting:$red_bold Python $PYTHON_VERSION source at: /usr/src$normal\n"
sudo tar zxf Python-$PYTHON_VERSION.tgz > /dev/null 2>&1

cd Python-$PYTHON_VERSION
printf "$green_bold[BUILDING]\t$normal   - Building:$red_bold Python $PYTHON_VERSION (This will take some minutes)$normal\n"
sudo ./configure --enable-optimizations > /dev/null 2>&1
sudo make altinstall > /dev/null 2>&1

printf "$green_bold[CLEANUP]\t$normal   - Cleaning:$red_bold Python $PYTHON_VERSION source files$normal\n"
sudo rm /usr/src/Python-$PYTHON_VERSION.tgz > /dev/null 2>&1


printf "$normal\n\n############################################################################$normal\n"
printf "$normal\t\t[CONFIGURING] PYTHON $PYTHON_VERSION$normal\n"
printf "$normal############################################################################$normal\n"

# Enabling aliases expasion on a shell script
# https://askubuntu.com/questions/98782/how-to-run-an-alias-in-a-shell-script
shopt -s expand_aliases

printf "$green_bold[SOURCING]$normal\t  - Sourcing: $red_bold Exports at $EXPORTS$normal\n"
. $EXPORTS

printf "$green_bold[ADDING]$normal\t  - Packet: $red_bold Virtualenv to the PATH$normal\n"
export PATH="$HOME/.local/bin:$PATH"

printf "$green_bold[INSTALLING]$normal - Packet: $red_bold Virtualenv $normal\n"
pip$PIP_VERSION install virtualenv > /dev/null 2>&1

printf "$green_bold[CREATING]$normal\t  - Directory for Virtualenv :$red_bold At $USER_DIR$VENV_NAME/$normal\n"
mkdir -p $USER_DIR$VENV_NAME/

printf "$green_bold[CREATING]$normal\t  - Virtualenv:$red_bold At $USER_DIR$VENV_NAME/$normal\n"
virtualenv -p python$PIP_VERSION $USER_DIR$VENV_NAME/ > /dev/null 2>&1
cd $USER_DIR$VENV_NAME/
source bin/activate

# This needs to install requirements.txt
printf "$green_bold[INSTALLING]$normal - Packet: $red_bold nornir $normal\n"
pip$PIP_VERSION install nornir > /dev/null 2>&1

printf "\n\n"