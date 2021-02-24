#!/bin/bash

# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

C2_NAME="haproxy-dev"
HAP_EXPORTS="/home/ubuntu/${C2_NAME}/exports"
export USER_PASS='$6$lU4HtFdy.D$sFSkyH13/HjQsFdC8o3i5bgic6xhkLmhcaOu.i9eihGXMoAw6IQtbRs61H0d.fqRj0QNjiaDVhQRRFXyFRxaI1'

PYTHON_PCKS=(
        haproxy
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

# =================================================================== # Script # ===================================================================


printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[INSTALLING] HAPROXY (On Container: ${C2_NAME})${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at '${HAP_EXPORTS}' ${normal}\n"
. ${HAP_EXPORTS} 


printf "${green_bold}[UPDATING]${normal} - APT: ${red_bold}(This may take some minutes)${normal}\n"
sudo apt-get -qqy update > /dev/null 2>&1

INST_PACK "${PYTHON_PCKS[@]}"
printf "${normal}\n"



printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[CREATING] SUDO ADMIN USER '${USER_ADM}' (On Container: ${C2_NAME})${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[CREATING]${normal} - User: ${red_bold}'${USER_ADM}'${normal}\n"
printf "${green_bold}[PASS-HASH]:${normal} - Pass: ${red_bold}'${USER_PASS}'${normal}\n"
sudo useradd -m -p ${USER_PASS} -s /bin/bash -g sudo ${USER_ADM}

printf "${green_bold}[SUDO]:${normal} - Passwordless User: ${red_bold}'${USER_ADM}'${normal}\n"
echo "${USER_ADM} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

