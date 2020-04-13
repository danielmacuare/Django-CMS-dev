#!/bin/bash

# ===================================================================
# provisioning.sh
# DESCRIPTION =======================================================
# Provisioning file for a django-cms dev environment 
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
ANSIBLE_TAG="v2.6.0"
ANS_REPO="/vagrant_data/ansible/"       # Point to this location on your Vagrantfile.
USER_DIR="/home/vagrant/"
PYTHON_PACKS=(
        epel-release
        yamllint
        yum-utils               #https://janikarhunen.fi/how-to-install-python-3-6-1-on-centos-7.html
        https://centos7.iuscommunity.org/ius-release.rpm
        python36u
        python36u-pip
        python36u-devel
        dh-autoreconf                   # Requirement to install libyaml
        http://rpms.remirepo.net/enterprise/remi-release-7.rpm   # Requirement to install PHP7.2 via YUM
)

sudo apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
sudo tar zxf Python-3.7.4.tgz 
cd Python-3.7.4
sudo ./configure --enable-optimizations
sudo make altinstall


# =================================================================== # Functions # ===================================================================
INST_PACK(){
for PCKGS in "$@"; do
        printf "$green_bold[INSTALLING]$normal - Packet: $red_bold$PCKGS$normal\n"
        sudo yum --quiet -y install $PCKGS > /dev/null 2>&1
        # printf "\n\n"

done
}


# =================================================================== # Initial setup for Ansible # ===================================================================
printf "$normal\n\n############################################################################$normal\n"
printf "$normal\t\tINSTALLING YUM PACKAGES TO RUN ANSIBLE$normal\n"
printf "$normal############################################################################$normal\n"

INST_PACK "${APT_PACKS[@]}"
printf "\n\n"

#Pre task to install PHP72 with Ansible
printf "$green_bold[ENABLING]\t$normal - Repo: $red_bold Remi repo for php-72 $normal"
sudo yum-config-manager --enable remi-php72

# First Update after yum packets
printf "$green_bold[UPDATING]\t\t$normal - $red_bold YUM (This may take some minutes) $normal"
# sudo yum --quiet -y update
sudo yum -y update > /dev/null 2>&1
printf "\n"


# LibYaml - https://github.com/yaml/libyaml
printf "$green_bold[GIT CLONING]$normal\t - Packet: $red_bold Libyaml $normal"
git clone https://github.com/yaml/libyaml.git > /dev/null 2>&1

printf "$green_bold[INSTALLING]$normal\t - Packet: $red_bold Libyaml $normal"
cd libyaml/
./bootstrap > /dev/null 2>&1
./configure > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1

printf "$green_bold[REMOVING]$normal\t\t - Packet: $red_bold Libyaml Repository$normal"
cd ..
rm -rf libyaml/
printf "\n\n"


# PIP 3.6
printf "$green_bold[UPGRADING]$normal\t - Packet: $red_bold Pip3.6 $normal"
sudo pip3.6 install --upgrade pip 2>&1 > /dev/null
printf "\n\n"


# VENV
printf "$green_bold[INSTALLING]$normal\t - Packet: $red_bold Virtualenv $normal"
pip3 install virtualenv > /dev/null 2>&1

printf "$green_bold[CREATING]$normal\t\t - Packet: $red_bold Virtualenv Name: $VENV_NAME$normal"
virtualenv -p python3.6 $USER_DIR$VENV_NAME/ > /dev/null 2>&1
cd $USER_DIR$VENV_NAME/
source bin/activate > /dev/null 2>&1
printf "\n\n"


# ANSIBLE - Through GIT - Requires Python >= 3.5
printf "$green_bold[GIT CLONING]$normal\t - Packet: $red_bold Ansible $ANSIBLE_TAG$normal"
git clone https://github.com/ansible/ansible.git > /dev/null 2>&1
cd ansible/
git checkout $ANSIBLE_TAG > /dev/null 2>&1

printf "$green_bold[INSTALLING]$normal\t - Packet: $red_bold Ansible $ANSIBLE_TAG$normal"
python3.6 setup.py install > /dev/null 2>&1

# ANSIBLE - Through PIP
# printf "$green_bold[PIP INSTALLING]$normal - Packet: $red_bold Ansible $ANSIBLE_TAG$normal"
# pip3.6 install ansible
# printf "\n\n"

printf "$green_bold[REMOVING]\t$normal\t - Packet: $red_bold Ansible Repository $ANSIBLE_TAG$normal"
cd ..
rm -rf ansible/
printf "\n\n"

printf "$green_bold[PERMISSIONS]$normal\t - chown -R: $red_bold$VENV_NAME is now owned by vagrant:vagrant$normal"
cd ..
chown -R vagrant:vagrant $VENV_NAME/ 2>&1 > /dev/null
printf "\n\n"

printf "$normal############################################################################$normal\n"
printf "$normal\t\tANSIBLE - Centos7 PROVISIONING$normal\n"
printf "$normal############################################################################$normal\n"
cp -R $ANS_REPO $USER_DIR$VENV_NAME/ansible/
cd $USER_DIR$VENV_NAME/ansible
ansible-playbook main.yaml
printf "\n\n"

# ===================================================================
# YUM UPGRADE/UPDATE
# ===================================================================
printf "$green_bold[UPDATING]$normal\t - $red_bold YUM $normal"
sudo yum -y update > /dev/null 2>&1

printf "$green_bold[UPGRADING]$normal - $red_bold YUM $normal"
sudo yum --quiet -y upgrade > /dev/null 2>&1
printf "$normal\n\n############################################################################$normal\n"
printf "$normal\t\tINITIAL SETUP IS FINISHED$normal\n"
printf "$normal############################################################################$normal"
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About

