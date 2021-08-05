#!/usr/bin/env bash
##
## Script to run on the live cd/usb
##

## stop the planet from spinning when an error occurs
# set -e

if [ "$BASH_VERSION" = '' ] && [ ! $(grep -aq bash /proc/$$/cmdline) ]; then
    echo "This script must be run in bash !!!"
    echo "If running with another shell it may cause unespected behaviour ..."
    return 1
fi

## we will need a bigger size for the live environment
mount -o remount,size=1G /run/archiso/cowspace
## and update the mirrors
pacman -Syy &>/dev/null

## avoid sudo asking for password for current user and the new user
## this will be deleted in the cleanup function at the end
echo "${USER}     ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/install.sudo
echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/install.sudo

## show some nice messages to the user
## we all like colors don't we
msg_ok()      { echo "$(tput setaf 2)[+] $1$(tput sgr0)";       }
msg_error()   { echo "$(tput setaf 1)[ERROR] $1$(tput sgr0)";   }
msg_warning() { echo "$(tput setaf 3)[WARNING] $1$(tput sgr0)"; }


read -p  "$(tput setaf 2)[?] Disk name to use for the install (ex:/dev/nvme0n1):$(tput sgr0) " tmp_DISKNAME
read -p  "$(tput setaf 2)[?] Use LUKS encryption (default 'YES') [Y/n]:$(tput sgr0)          " tmp_SHOULD_ENCRYPT_DISK

SHOULD_ENCRYPT_DISK=${tmp_SHOULD_ENCRYPT_DISK:-"Y"}
if [[ $SHOULD_ENCRYPT_DISK =~ [Yy] ]]; then
    read -sp "$(tput setaf 2)[?] Password to encrypt the LUKS volume:$(tput sgr0) " tmp_CRYPT_PASSWORD
    read -p  "$(tput setaf 2)[?] LUKS volume name (default: root):$(tput sgr0)    " tmp_PARTITION_LUKS_INPUT
fi


if ls /dev/nvme0n1 &>/dev/null; then
    DISKNAME=${tmp_DISKNAME:-"/dev/nvme0n1"}
    PARTITION1="${DISKNAME:-"/dev/nvme0n1"}p1"  # UEFI partition (/dev/nvme0n1)
    PARTITION2="${DISKNAME:-"/dev/nvme0n1"}p2"  # disk partition LUKS encrypted (/dev/nvme0n1p2)
else
    DISKNAME=${tmp_DISKNAME:-"/dev/sda"}
    PARTITION1="${DISKNAME:-"/dev/sda"}1"  # UEFI partition (/dev/sda1)
    PARTITION2="${DISKNAME:-"/dev/sda"}2"  # disk partition LUKS encrypted (/dev/sda2)
fi

## if there is no disk encryption we need to change the
## partition name for PARTITION_LUKS variable to ex: /dev/sda2
if [[ $SHOULD_ENCRYPT_DISK =~ [Yy] ]]; then
    CRYPT_PASSWORD=${tmp_CRYPT_PASSWORD:-"sup3rs3cur3"}
    PPARTITION_LUKS=${tmp_PARTITION_LUKS_INPUT:-"root"}
    PARTITION_LUKS="/dev/mapper/${PPARTITION_LUKS}"
else
    PARTITION_LUKS=${PARTITION2}
fi


## if you want to change the font
# setfont sun12x22
loadkeys fr_CH-latin1
timedatectl set-ntp true


## Partition the disk
##
if [[ -b ${DISKNAME} ]]; then
    msg_ok "Partitionning DISK=${DISKNAME}"
    parted --script ${DISKNAME} \
        mklabel gpt \
        mkpart ESP fat32 1MiB 551MiB \
        set 1 esp on \
        mkpart primary ext4 551MiB 100%
else
    msg_error "No disk named -> ${DISKNAME}"
    exit 1
fi


## Encrypt the hole partition
##
if [[ $SHOULD_ENCRYPT_DISK =~ [Yy] ]]; then
    msg_ok "Luks formating partition ${PARTITION2}"
    lsmod | grep dm_crypt || modprobe dm_crypt
    echo -n "${CRYPT_PASSWORD}" | cryptsetup -q luksFormat ${PARTITION2} -
    msg_ok "Luks open partition ${PARTITION2}"
    echo -n "${CRYPT_PASSWORD}" | cryptsetup open --type luks ${PARTITION2} root -
    unset ${CRYPT_PASSWORD}

    msg_ok "Checking if ${PARTITION_LUKS} is present"
    if ! test -b ${PARTITION_LUKS}; then
        echo "$(tput setaf 1)[!!!] Luks partition not found (${PARTITION_LUKS}) [!!!]$(tput sgr0)"
        exit 1;
    fi
fi


## Add filesystems to the partitions
##
msg_ok "Creating fat32 filesystem on ${PARTITION1}"
mkfs.fat -F32 ${PARTITION1} || msg_error "[mkfs.fat] -> No partition with the name ${PARTITION1}"

msg_ok "Creating ext4 filesystem on ${PARTITION_LUKS}"
mkfs.ext4 ${PARTITION_LUKS} || msg_error "[mkfs.ext4] -> No root partition with the name ${PARTITION_LUKS}"

msg_ok "Mounting ${PARTITION2} on /mnt"
mount ${PARTITION_LUKS} /mnt || msg_error "[mount] -> No root partition with the name ${PARTITION_LUKS}"

msg_ok "Mounting ${PARTITION1} on /mnt/boot"
mkdir /mnt/boot
mount ${PARTITION1} /mnt/boot || msg_error "[mount] -> No boot partition with the name ${PARTITION1}"


## Use faster pacman mirrors
##
msg_ok "Generate pacman mirrorlist"
pacman -S --noconfirm pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector --country 'Switzerland' --latest 200 --protocol https --protocol http --age 12 --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist
msg_ok "Refresh pacman database"
pacman -Syy


## Install required packages in chroot
##
msg_ok "Installing some packages"
# would recommend to use linux-lts kernel, otherwise just use "linux"
# pacstrap /mnt $(pacman -Sqg base | sed 's/^linux$/&-lts/') base-devel openssh sudo ntp wget vim curl wget git
pacstrap /mnt base base-devel \
    linux-lts linux-lts-headers linux-firmware \
    intel-ucode linux-firmware pacman-contrib \
    openssh sudo ntp wget gvim curl wget git \
    vim git zsh zh-syntax-highlighting zsh-autosuggestions


## Generate fstab
##
msg_ok "Generate /etc/fstab with UUIDs"
genfstab -pU /mnt >> /mnt/etc/fstab
msg_ok "Adding /swapfile to /etc/fstab"
echo "/swapfile none swap defaults 0 0" >> /mnt/etc/fstab


## Copy script into chroot
##
msg_ok "Copy the chroot install script to /mnt"
cp ./sysprep_archlinux_chroot.sh /mnt
chmod +x /mnt/sysprep_archlinux_chroot.sh


## Continue the installation from the chroot
##
msg_ok "Swithing to arch-chroot in /mnt"
arch-chroot /mnt chmod +x /sysprep_archlinux_chroot.sh
arch-chroot /mnt /sysprep_archlinux_chroot.sh ${PARTITION2} ${SHOULD_ENCRYPT_DISK} ${PARTITION_LUKS}


## Unmount all filesystems
##
msg_ok "Unmounting all filesystems"
umount -R /mnt
if [[ $SHOULD_ENCRYPT_DISK =~ [Yy] ]]; then
    msg_ok "Closing LUKS volume ..."
    cryptsetup close ${PARTITION_LUKS}
fi

msg_ok "#########################################"
msg_ok " ALL DONE YOU CAN REBOOT YOUR SYSTEM NOW"
msg_ok "#########################################"

read -p "$(tput setaf 2)[?] REBOOT SYSTEM [Y/n]:$(tput sgr0) " REBOOT_WHEN_FINISH
if ! [[ $REBOOT_WHEN_FINISH =~ [Nn] ]]; then
    reboot
fi
