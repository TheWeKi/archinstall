#!/usr/bin/env bash

keyboardlayout="us"
zoneinfo="Asia/Kolkata"
hostname="archlinux"
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

#chaotic-aur setup
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | tee -a /etc/pacman.conf
pacman -Syy

# Other Packages
pacman --noconfirm -S grub efibootmgr grub-btrfs wireplumber pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack gst-plugin-pipewire bluez bluez-utils openssh thermald firewalld plocate

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
systemctl enable ModemManager.service
systemctl enable bluetooth.service
systemctl enable sshd.service
systemctl enable thermald.service
systemctl enable firewalld.service

systemctl enable paccache.timer
systemctl enable fstrim.timer
systemctl enable reflector.timer
systemctl enable plocate-updatedb.timer

# Corruption recovery -> btrfs-check
sed -i 's/BINARIES=()/BINARIES=(btrfs)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

# Enable Sudoers permission for wheel group and Add User to wheel group
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
usermod -aG wheel $username
