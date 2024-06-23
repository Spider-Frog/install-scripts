#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Amd drivers install script by SpiderFrog"

while true; do
    read -p "This script will install Amd drivers, Do you wan't to continue? (yes/no): " yesno
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
echo "Installing Amd drivers..."

sudo pacman -S mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau

echo "Done."
echo ""
echo "Finished! Amd drivers are now installed."