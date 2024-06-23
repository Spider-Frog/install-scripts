#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Installing Wayland..."
pacman -S --needed wayland
pacman -S --needed gdm
pacman -S --needed xorg-xwayland xorg-xlsclients glfw-wayland

echo ""
echo "Installing Gnome..."
pacman -S --needed gnome gnome-tweaks gnome-shell-extensions gnome-browser-connector gnome-console gnome-calculator gnome-calendar gnome-control-center\
                   xdg-user-dirs-gtk fwupd papirus-icon-theme adwaita-icon-theme


echo "Done."
echo ""
echo "Setting up chaotic-aur repository..."

pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

echo ""
echo "Installing Pamac-Aur..."

pacman -Syu pamac-aur

# Check if gnome-software is installed
if pacman -Qs gnome-software > /dev/null; then
    echo ""
    echo "gnome-software found, uninstalling..."
    sudo pacman -Rns gnome-software
fi

echo "Done."
echo ""
echo "Enabling Gnome..."

systemctl enable gdm

echo "Done."
echo ""
echo "Finished! Gnome is now installed!"
echo "Please reboot your system."