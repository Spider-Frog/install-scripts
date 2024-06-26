#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Installing aur..."

pacman -S --needed git base-devel

git clone https://aur.archlinux.org/yay.git

cd /temp/yay && makepkg -si

cd ..

rm -rf /temp/yay

echo "Done."