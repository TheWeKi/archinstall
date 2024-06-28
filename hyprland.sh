#!/usr/bin/env bash

pacman -Syy

pacman --noconfirm -S hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland
pacman --noconfirm -S hyprpaper hypridle hyprlock hyprcursor nwg-panel
pacman --noconfirm -S alacritty firefox thunar
pacman --noconfirm -S swaync polkit-gnome rofi-wayland waybar cliphist unzip mpv
pacman --noconfirm -S ttf-jetbrains-mono-nerd font-manager nwg-look qt6-svg qt6-declarative starship

pacman --noconfirm -S sddm
systemctl enable sddm.service

sleep 1

git clone https://github.com/theweki/desktop-environment.git
cd desktop-environment/

sleep 1

./install.sh

sleep 2