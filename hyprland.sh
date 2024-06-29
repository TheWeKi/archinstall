#!/usr/bin/env bash

pacman -Syy

# hyprland bloat
pacman --noconfirm -S kitty

pacman --noconfirm -S hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland qt6-svg qt6-declarative
pacman --noconfirm -S hyprpaper hypridle hyprlock hyprcursor nwg-panel nwg-look
pacman --noconfirm -S swaync polkit-gnome rofi-wayland waybar
pacman --noconfirm -S alacritty firefox thunar cliphist unzip mpv
pacman --noconfirm -S font-manager starship

pacman --noconfirm -S sddm
systemctl enable sddm.service

sleep 1
