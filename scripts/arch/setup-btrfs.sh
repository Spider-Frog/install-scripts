#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Setting up btrfs to automatically create snapshots"
echo ""

echo "Enabling automatic snapshot boot entries update..."

SERVICE_FILE="/etc/systemd/system/grub-btrfsd.service"

if [ -f "$SERVICE_FILE" ]; then
    echo "Creating a backup of the original service file at $BACKUP_FILE"
else
    echo "Service file not found at $SERVICE_FILE"
    exit 1
fi

sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto|' "$SERVICE_FILE"

systemctl enable grub-btrfsd

echo "Done."
echo ""
echo "Installing aur..."

pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

echo "Done."
echo ""
echo "Installing timeshift-autosnap for automatic snapshot when using pacman..."

yay -S timeshift-autosnap

echo "Done."
echo ""
echo "Finished! Automatic btrfs snapshots are now enabled."