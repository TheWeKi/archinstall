#!/usr/bin/env bash

keyboardlayout="us"
zoneinfo="Asia/Kolkata"
hostname="localhost"
username="weki"

ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

# Pacman Config
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
pacman -Syy

# Mirror Selection
pacman --noconfirm -S reflector
reflector -c "India" -p https -a 7 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

# Microcodes
pacman --noconfirm -S intel-ucode amd-ucode

# Firmware
pacman --noconfirm -S sof-firmware linux-firmware-marvell

# Server
pacman --nocinfirm -S xorg-server xorg-xinit

# File System
pacman --noconfirm -S btrfs-progs e2fsprogs

# Graphic Drivers
# pacman --noconfirm -S mesa vulkan-radeon vulkan-intel vulkan-nouveau xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-nouveau xf86-video-vmware intel-media-driver libva-intel-driver libva-mesa-driver

# Bootloader
pacman --noconfirm -S grub efibootmgr os-prober grub-btrfs

# Network
pacman --noconfirm -S networkmanager network-manager-applet

# Bluetooth
pacman --noconfirm -S bluez bluez-utils blueman

# Printer
pacman --noconfirm -S cups

# Audio
pacman --noconfirm -S wireplumber pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack gst-plugin-pipewire pavucontrol

# Others
pacman --noconfirm -S base-devel man nano


# echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "KEYMAP=$keyboardlayout" >> /etc/vconsole.conf

echo "$hostname" >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Set Root Password"
passwd

useradd -m $username
echo "Enter User Password: "
passwd $username

# Start Services
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable cups.service
systemctl enable reflector.timer
systemctl enable fstrim.timer

# Corruption recovery -> btrfs-check
sed -i 's/BINARIES=()/BINARIES=(btrfs)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

# Enable Sudoers permission for wheel group and Add User to wheel group
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
usermod -aG wheel $username

##########################
## OTHER CONFIGURATIONS ##
##########################

pacman --noconfirm -S git

