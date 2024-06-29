#!/usr/bin/env bash

pacman --noconfirm -S gdm gnome gnome-extra

sleep 1

systemctl enable gdm

sleep 2