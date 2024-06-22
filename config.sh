#!/usr/bin/env bash

keyboardlayout="us"
zoneinfo="Asia/Kolkata"
hostname="localhost"
username="weki"

ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

pacman --noconfirm -S reflector

reflector -c "India," -p https -a 3 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

pacman --noconfirm -S grub efibootmgr linux-headers grub-btrfs networkmanager nano vim xdg-utils xorg-server git

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "KEYMAP=$keyboardlayout" >> /etc/vconsole.conf

echo "$hostname" >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts

echo "Set Root Password"
passwd root

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

useradd -m -G wheel $username
echo "Enter User Password: "
passwd $username

systemctl enable NetworkManager
# systemctl enable bluetooth
# systemctl enable cups.service
# systemctl enable sshd
systemctl enable reflector.timer
systemctl enable fstrim.timer

# sed -i 's/BINARIES=()/BINARIES=(btrfs setfont)/g' /etc/mkinitcpio.conf
# mkinitcpio -p linux

echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=vim sudo -E visudo

usermod -aG wheel $username
