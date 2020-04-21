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
# COLORS
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

EXPORTS="/vagrant_data/exports"
export USER_PASS='$6$lU4HtFdy.D$sFSkyH13/HjQsFdC8o3i5bgic6xhkLmhcaOu.i9eihGXMoAw6IQtbRs61H0d.fqRj0QNjiaDVhQRRFXyFRxaI1'


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

# =================================================================== # Functions # ===================================================================
INST_PACK(){
for PCKGS in "$@"; do
        printf "${green_bold}[INSTALLING]${normal} - Packet: ${red_bold}$PCKGS${normal}\n"
        sudo apt-get -qqy --no-install-recommends install $PCKGS > /dev/null 2>&1
done
}

# =================================================================== # Initial setup for Python # ===================================================================

# Enabling aliases expasion on a shell script
# https://askubuntu.com/questions/98782/how-to-run-an-alias-in-a-shell-script
shopt -s expand_aliases

printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at $EXPORTS${normal}\n"
. $EXPORTS

# Initial APT Update 
printf "${green_bold}[UPDATING]${normal} - APT: ${red_bold}(This may take some minutes)${normal}\n"
sudo apt-get -qqy update > /dev/null 2>&1


printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CREATING] SUDO ADMIN USER '${USER_ADM}' ${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[CREATING]${normal} - User: ${red_bold}'${USER_ADM}'${normal}\n"
echo "User: ${USER_ADM}"
echo "Pass: ${USER_PASS}"
sudo useradd -p ${USER_PASS} -s /bin/bash -g sudo ${USER_ADM}




printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CONFIGURING] SERVICE: SSH ${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[RUNNING]${normal}\t  - Shell Script: ${red_bold}'${SHARED_DIR}/files/sh_scripts/ssh_service.sh'  ${normal}\n"
sudo bash ${SHARED_DIR}/files/sh_scripts/ssh_service.sh


printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[BUILDING] PYTHON $PYTHON_VERSION FROM SOURCE ${normal}\n"
printf "${normal}############################################################################${normal}\n"

INST_PACK "${PYTHON_PCKS[@]}"
printf "\n"


cd /usr/src
printf "${green_bold}[DOWNLOADING]${normal} - Downloading:${red_bold} Python $PYTHON_VERSION${normal}\n"
sudo wget -q -nv https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz

printf "${green_bold}[EXTRACTING]${normal}  - Extracting:${red_bold} Python $PYTHON_VERSION source at: /usr/src${normal}\n"
sudo tar zxf Python-$PYTHON_VERSION.tgz > /dev/null 2>&1

cd Python-$PYTHON_VERSION
printf "${green_bold}[BUILDING]\t${normal}   - Building:${red_bold} Python $PYTHON_VERSION (This will take some minutes)${normal}\n"
sudo ./configure --enable-optimizations > /dev/null 2>&1
sudo make altinstall > /dev/null 2>&1

printf "${green_bold}[CLEANUP]\t${normal}   - Cleaning:${red_bold} Python $PYTHON_VERSION source files${normal}\n"
sudo rm /usr/src/Python-$PYTHON_VERSION.tgz > /dev/null 2>&1


printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CONFIGURING] PYTHON $PYTHON_VERSION${normal}\n"
printf "${normal}############################################################################${normal}\n"


printf "${green_bold}[ADDING]${normal}\t  - Packet: ${red_bold}Virtualenv to the PATH${normal}\n"
export PATH="${USER_DIR}/.local/bin:$PATH"

printf "${green_bold}[INSTALLING]${normal} - Packet: ${red_bold}Virtualenv ${normal}\n"
pip$PIP_VERSION install virtualenv > /dev/null 2>&1

printf "${green_bold}[CREATING]${normal}\t  - Directory for Virtualenv:${red_bold} At $USER_DIR$VENV_NAME/${normal}\n"
mkdir -p $USER_DIR$VENV_NAME/

printf "${green_bold}[CREATING]${normal}\t  - Virtualenv:${red_bold} At $USER_DIR$VENV_NAME/${normal}\n"
virtualenv -p python$PIP_VERSION $USER_DIR$VENV_NAME/ > /dev/null 2>&1
cd $USER_DIR$VENV_NAME/
source bin/activate

printf "${green_bold}[INSTALLING]${normal} - PIP: ${red_bold}requirements.txt ${normal}\n"
python -m pip install -r ${PYTHON_REQ} > /dev/null 2>&1



printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CREATING] CONFIG TEMPLATES ${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[PYTHON]${normal} - Executing: ${red_bold}'/vagrant_data/config.py'  ${normal}\n"
cd ${SHARED_DIR}
python config.py