#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Setup Btrfs script by SpiderFrog"

while true; do
    read -p "This script will complete the Btrfs setup for you, Do you wan't to continue? (yes/no): " yesno
    case $yesno in
        [Yy]* )
            break
        ;;
        [Nn]* )
            exit
        ;;
        * ) echo "Answer either yes or no!";;
    esac
done

echo ""
echo "Enabling automatic snapshot boot entries update..."

SERVICE_FILE="/etc/systemd/system/grub-btrfsd.service"

sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto|' "$SERVICE_FILE"

systemctl enable grub-btrfsd

echo "Done."
echo ""
echo "Installing aur..."

pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
rm -rf ./yay

echo "Done."
echo ""
echo "Installing timeshift-autosnap for automatic snapshot when using pacman..."

yay -S timeshift-autosnap

echo "Done."
echo ""
echo "Finished! Automatic btrfs snapshots are now enabled."