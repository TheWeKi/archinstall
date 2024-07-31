#!/usr/bin/env bash

pacman --noconfirm -S xorg xorg-xinit fwupd gnome gnome-tweaks gnome-themes-extra power-profiles-daemon gnome-remote-desktop switcheroo-control cups usbutils
pacman --noconfirm -S noto-fonts noto-fonts-extra noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd vlc
pacman --noconfirm -S mesa vulkan-intel intel-media-driver libva-utils libva-intel-driver

sleep 1

# systemctl enable power-profiles-daemon.service
systemctl enable gdm.service
systemctl enable switcheroo-control.service

systemctl enable cups.socket
systemctl enable avahi-daemon.socket

sleep 2

# nodejs npm jdk-openjdk docker docker-compose go visual-studio-code-bin postman-bin spotify discord google-chronme intellij-idea-ultimate-edition
