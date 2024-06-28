#!/usr/bin/env bash

## # # # ## # # # # ##
## PRE INSTALLATION ##
## # # # ## # # # # ##

# Make Automation For Disk Selection, Format and SELF PARTITION - EFI, SWAP, ROOT

loadkeys us
setfont ter-132b

timedatectl set-timezone Asia/Kolkata
timedatectl set-ntp true

# READ Partitions Here For EFI, SWAP, ROOT
lsblk

read -p "EFI Partition   |  nvme0n1p1 / sda1 / vda1 :   " EFI
read -p "SWAP Partition  |  nvme0n1p2 / sda2 / vda2 :   " SWAP
read -p "Root Partition  |  nvme0n1p3 / sda3 / vda3 :   " ROOT

# Format Partitions
mkfs.fat -F 32 /dev/$EFI
mkswap /dev/$SWAP
mkfs.btrfs -f /dev/$ROOT

# Mount ROOT and Creating SUBVOLUMES
mount /dev/$ROOT /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@snapshots
umount /mnt

# Mounting Each SUBVOLUMES with ZSTD Compression
mount -o compress=zstd:1,noatime,subvol=@ /dev/$ROOT /mnt

mkdir /mnt/home
mount -o compress=zstd:1,noatime,subvol=@home /dev/$ROOT /mnt/home

mkdir -p /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@cache /dev/$ROOT /mnt/var/cache

mkdir -p /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@log /dev/$ROOT /mnt/var/log

mkdir /mnt/.snapshots
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$ROOT /mnt/.snapshots

# Mounting EFI
mkdir -p /mnt/boot/efi
mount /dev/$EFI /mnt/boot/efi

# SWAP ON
swapon /dev/$SWAP

# Pacman Conf
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
reflector -c "India" -p https -a 4 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

# BASE LINUX PACKAGES
pacstrap -K /mnt base linux linux-firmware

# Generating FSTAB
genfstab -U /mnt >> /mnt/etc/fstab

# # # # # # # # # # #
# # CONFIGURATION # #
# # # # # # # # # # #

mkdir /mnt/archinstall
cp config.sh /mnt/archinstall
cp desktop.sh /mnt/archinstall

arch-chroot /mnt ./archinstall/config.sh
# arch-chroot /mnt ./archinstall/desktop.sh

rm -rf /mnt/archinstall
umount -R /mnt

echo "Installation Completed. You can reboot now."