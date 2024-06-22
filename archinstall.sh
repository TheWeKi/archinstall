#!/usr/bin/env bash

## # # # ## # # # # ##
## PRE INSTALLATION ##
## # # # ## # # # # ##

loadkeys us
set-font ter-132b

pacman -Syy

timedatectl set-timezone Asia/Kolkata
timedatectl set-ntp true

lsblk
# READ Partitions Here For EFI, SWAP, ROOT

read -p "EFI Partition e.g., nvme0n1p1: " EFI
read -p "SWAP Partition e.g., nvme0n1p2: " SWAP
read -p "Root Partition e.g., nvme0n1p3: " ROOT

keyboardlayout="us"
zoneinfo="Asia/Kolkata"
hostname="localhost"
username="weki"

mkfs.fat -F 32 /dev/$EFI
mkswap /dev/$SWAP
mkfs.btrfs -f /dev/$ROOT

mount /dev/$ROOT /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt

mount -o compress=zstd:1,noatime,subvol=@ /dev/$ROOT /mnt

mkdir /mnt/home
mount -o compress=zstd:1,noatime,subvol=@home /dev/$ROOT /mnt/home

mkdir -p /mnt/boot/efi
mount /dev/$EFI /mnt/boot/efi

swapon /dev/$SWAP

pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode amd-ucode btrfs-progs

genfstab -U /mnt >> /mnt/etc/fstab

# # # # # # # # # # #
# # CONFIGURATION # #
# # # # # # # # # # #

mkdir /mnt/archinstall
cp config.sh /mnt/archinstall

arch-chroot /mnt ./archinstall/config.sh
