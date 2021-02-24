#!/bin/bash
# Vars
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

PYTHON_PCKS=(
    lxc-utils
    zfsutils-linux 
    zfs-initramfs 
)


# =================================================================== # Functions # ===================================================================
INST_PACK(){
for PCKGS in "$@"; do
        printf "${green_bold}[INSTALLING]${normal} - Packet: ${red_bold}$PCKGS${normal}\n"
        sudo apt-get -qqy --no-install-recommends install $PCKGS > /dev/null 2>&1
done
}

# =================================================================== # Script # ===================================================================
printf "${green_bold}[SOURCING]${normal}\t  - Sourcing: ${red_bold}Variables at '/vagrant_data/exports'${normal}\n"
. /vagrant_data/exports

INST_PACK "${PYTHON_PCKS[@]}"
printf "\n"

# Adds the user and adjust permissions for the user
sudo usermod -a -G lxd ${USER_ADM} > /dev/null 2>&1
sudo chown damt -R ${USER_DIR} > /dev/null 2>&1


# Create an LXD Managed ZFS Pool storage
sudo lxc storage create ${ZFS_STORAGE_NAME} zfs source=${ZFS_DEV} zfs.pool_name=${ZFS_POOL_NAME} > /dev/null 2>&1


# NETWORK
# https://github.com/lxc/lxd/blob/master/doc/networks.md
# Delete default lxcbr0
sudo ip link set lxcbr0 down > /dev/null 2>&1
sudo brctl delbr lxcbr0 > /dev/null 2>&1

# Create a new bridge and delete the default
sudo lxc network create ${LXD_BRIDGE} ipv6.address=none ipv4.address=${LXD_BRIDGE_IP} ipv4.nat=true dns.domain=${LXD_DOMAIN_NAME} > /dev/null 2>&1

# specify a root disk device for the default profile 
sudo lxc profile device add default root disk path=/ pool=${ZFS_POOL_NAME} > /dev/null 2>&1

# Create a new profile dev-prof
sudo lxc profile copy default ${LXD_CST_PROFILE} > /dev/null 2>&1

# Attach the network bridge to the Default LXD Profile
sudo lxc network attach-profile ${LXD_BRIDGE} ${LXD_CST_PROFILE} eth0 > /dev/null 2>&1

# Already installed in 18.04
# Decide wheter you eant zfs or btrfs for your storage