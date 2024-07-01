#!/usr/bin/env bash

pacman --noconfirm -S gdm gnome gnome-remote-desktop firewalld modemmanager usb_modeswitch power-profiles-daemon switcheroo-control gnome-power-manager thermald plocate gnome-tweaks libreoffice-still firefox chromium ttf-jetbrains-mono-nerd mpv

# pacman --noconfirm -S mesa vulkan-radeon vulkan-intel vulkan-nouveau xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-nouveau xf86-video-vmware intel-media-driver libva-intel-driver libva-mesa-driver

########## GRAPHIC DRIVERS | H/W ACCELERATION ##################

# INTEL - xf86-video-intel not recommended 
pacman --noconfirm -S mesa vulkan-intel intel-media-driver libva-utils libva-intel-driver

sleep 1

systemctl enable gdm.service
systemctl enable firewalld.service
systemctl enable ModemManager.service
systemctl enable power-profiles-daemon.service
systemctl enable switcheroo-control.service
systemctl enable thermald.service
systemctl enable plocate-updatedb.timer

sleep 2