#!/usr/bin/env bash

pacman --noconfirm -S xorg xorg-xinit fwupd gnome gnome-tweaks gnome-themes-extra power-profiles-daemon gnome-remote-desktop switcheroo-control cups usbutils

pacman --noconfirm -S mesa vulkan-intel intel-media-driver libva-utils libva-intel-driver

sleep 1

# systemctl enable power-profiles-daemon.service
systemctl enable gdm.service
systemctl enable switcheroo-control.service

systemctl enable cups.socket
systemctl enable avahi-daemon.socket

sleep 2
