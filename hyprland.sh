#!/usr/bin/env bash

pacman -Sy

sleep 1

git clone https://github.com/theweki/desktop-environment.git
cd desktop-environment/

sleep 1

./install.sh

sleep 2