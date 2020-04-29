#!/bin/bash

# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

PYTHON_PCKS=(
        libsqlite3
        libsqlite3-dev
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
# https://stackoverflow.com/questions/10784132/django-no-module-named-sqlite3
# For Django CMS, SQLITE needs to be installed before building Python

C1_NAME="cms-dev"
CMS_EXPORTS="/home/ubuntu/${C1_NAME}/exports"
CMS_PYTHON_REQ="/home/ubuntu/${C1_NAME}/requirements.txt"
# pass=damt1234 (Test environment)
export USER_PASS='$6$lU4HtFdy.D$sFSkyH13/HjQsFdC8o3i5bgic6xhkLmhcaOu.i9eihGXMoAw6IQtbRs61H0d.fqRj0QNjiaDVhQRRFXyFRxaI1'

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



printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CREATING] SUDO ADMIN USER '${USER_ADM}' (On Container: ${C1_NAME}) ${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[CREATING]${normal} - User: ${red_bold}'${USER_ADM}'${normal}\n"
printf "${green_bold}[PASS-HASH]${normal} - Pass: ${red_bold}'${USER_PASS}'${normal}\n"
sudo useradd -m -p ${USER_PASS} -s /bin/bash -g sudo ${USER_ADM}

printf "${green_bold}[SUDO]${normal} - Passwordless Sudo: ${red_bold}'${USER_ADM}'${normal}\n"
echo "${USER_ADM} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers



printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[BUILDING] PYTHON $PYTHON_VERSION FROM SOURCE (On Container: cms-dev)${normal}\n"
printf "${normal}############################################################################${normal}\n"

#Initial APT Update 
printf "${green_bold}[UPDATING]${normal}   - APT: ${red_bold}(This may take some minutes)${normal}\n"
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

printf "${green_bold}[CLEANUP]${normal}     - Cleaning:${red_bold} Python $PYTHON_VERSION source files${normal}\n"
sudo rm /usr/src/Python-$PYTHON_VERSION.tgz > /dev/null 2>&1



printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CONFIGURING] PYTHON $PYTHON_VERSION (On Container: cms-dev)${normal}\n"
printf "${normal}############################################################################${normal}\n"


printf "${green_bold}[ADDING]${normal} - Packet: ${red_bold}Virtualenv to the PATH${normal}\n"
export PATH="${USER_DIR}/.local/bin:$PATH"

printf "${green_bold}[INSTALLING]${normal} - Packet: ${red_bold}Virtualenv ${normal}\n"
pip$PIP_VERSION install virtualenv > /dev/null 2>&1

printf "${green_bold}[CREATING]${normal}   - Directory for Virtualenv:${red_bold} At $USER_DIR$VENV_NAME/${normal}\n"
mkdir -p $USER_DIR$VENV_NAME/

printf "${green_bold}[CREATING]${normal}   - Virtualenv:${red_bold} At $USER_DIR$VENV_NAME/${normal}\n"
virtualenv -p python$PIP_VERSION $USER_DIR$VENV_NAME/ > /dev/null 2>&1
cd $USER_DIR$VENV_NAME/
source bin/activate

printf "${green_bold}[INSTALLING]${normal} - PIP: ${red_bold}${CMS_PYTHON_REQ}${normal}\n"
python -m pip install -r ${CMS_PYTHON_REQ} > /dev/null 2>&1

# Adds the user and adjust permissions for the user
printf "${green_bold}[PERMISSIONS]${normal} - Adjusting: ${red_bold}'${USER_DIR}' (On ${C1_NAME}.sh)${normal}\n"
sudo chown damt -R ${USER_DIR} > /dev/null 2>&1

## GOING BACK TO CMS-DEV.sh

# Continues on provisioning.sh

# ### Step by step
# # Create admin user
# useradd -m -p '$6$lU4HtFdy.D$sFSkyH13/HjQsFdC8o3i5bgic6xhkLmhcaOu.i9eihGXMoAw6IQtbRs61H0d.fqRj0QNjiaDVhQRRFXyFRxaI1' -s /bin/bash -g sudo damt

# # Passwordless sudo
# echo "damt ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# # Export path so you can use PIP
# export PATH="${USER_DIR}/.local/bin:$PATH"
# export PATH='/usr/local/bin:/home/damt/.local/bin:$PATH'

# # Installing virtualenv
# python3.8 -m pip install virtualenv


# sudo lxc exec cms-dev bash
# su damt
# source ~/venvs/py3e/bin/activate
# python -m pip install djangocms-installer
# sudo chown damt -R /home/damt/
# mkdir cms-damt
# cd cms-damt
# djangocms blog
# python manage.py runserver 0.0.0.0:8000

# Get the IP of 
# C1_NAME="cms-dev"
# C1_DIR="${SHARED_DIR}/${C1_NAME}"
# EXPORTS="/vagrant_data/exports"
# CMS_LXD_IP=$(sudo lxc list "cms-dev" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
# printf "\nCMS_IP=\"${CMS_LXD_IP}\"" >> ${EXPORTS}



#On vagrant the HOST 
# sudo lxc list "cms-dev" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}'
# iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80 -j DNAT --to-destination 10.10.20.157:8000



