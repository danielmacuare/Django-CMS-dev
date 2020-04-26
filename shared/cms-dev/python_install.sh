#!/bin/bash

# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

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
        whois
)

C1_NAME="cms-dev"
CMS_EXPORTS="/home/ubuntu/${C1_NAME}/exports"

# =================================================================== # Functions # ===================================================================
INST_PACK(){
for PCKGS in "$@"; do
        printf "${green_bold}[INSTALLING]${normal} - Packet: ${red_bold}$PCKGS${normal}\n"
        sudo apt-get -qqy --no-install-recommends install $PCKGS > /dev/null 2>&1
done
}

# =================================================================== # Script # ===================================================================
shopt -s expand_aliases

printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at '${CMS_EXPORTS}' ${normal}\n"
. ${CMS_EXPORTS} 

# Initial APT Update 
printf "${green_bold}[UPDATING]${normal} - APT: ${red_bold}(This may take some minutes)${normal}\n"
sudo apt-get -qqy update > /dev/null 2>&1

INST_PACK "${PYTHON_PCKS[@]}"
printf "\n"

cd /usr/src
printf "${green_bold}[DOWNLOADING]${normal} - Downloading:${red_bold} Python $PYTHON_VERSION${normal}\n"
sudo wget -q -nv https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz

printf "${green_bold}[EXTRACTING]${normal}  - Extracting:${red_bold} Python $PYTHON_VERSION source at: /usr/src${normal}\n"
sudo tar zxf Python-$PYTHON_VERSION.tgz > /dev/null 2>&1

cd Python-$PYTHON_VERSION
printf "${green_bold}[BUILDING]${normal}    - Building:${red_bold} Python $PYTHON_VERSION (This will take some minutes)${normal}\n"
sudo ./configure --enable-optimizations > /dev/null 2>&1
sudo make altinstall > /dev/null 2>&1

printf "${green_bold}[CLEANUP]${normal}   - Cleaning:${red_bold} Python $PYTHON_VERSION source files${normal}\n"
sudo rm /usr/src/Python-$PYTHON_VERSION.tgz > /dev/null 2>&1
