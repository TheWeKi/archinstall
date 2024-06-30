#!/usr/bin/env bash

pacman -Syy


##########################
## OTHER CONFIGURATIONS ##
##########################

# Shell
pacman --noconfirm -S zsh
chsh -s $(which zsh) $username

# Appearance
pacman --noconfirm -S ttf-jetbrains-mono-nerd


# hyprland bloat
pacman --noconfirm -S kitty

# hyprland essentials
pacman --noconfirm -S hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland qt6-svg qt6-declarative
pacman --noconfirm -S hyprpaper hypridle hyprlock hyprcursor nwg-panel nwg-look
pacman --noconfirm -S swaync polkit-gnome rofi-wayland waybar network-manager-applet bluez bluez-utils blueman pavucontrol grim slurp htop fastfetch

# hyprland utilities
pacman --noconfirm -S thunar cliphist unzip mpv font-manager firefox alacritty starship

# display manager
pacman --noconfirm -S sddm
systemctl enable sddm.service

sleep 1

# Others
pacman --noconfirm -S libreoffice-still

# Power Management
pacman --noconfirm -S thermald
systemctl enable thermald.service

sleep 1