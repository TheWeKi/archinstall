#!/usr/bin/env bash

pacman -S gdm gnome gnome-extra

sleep 1

systemctl enable gdm

sleep 2