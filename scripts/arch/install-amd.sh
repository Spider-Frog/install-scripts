#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Installing Amd drivers..."

sudo pacman -S mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau

echo "Done."
echo ""
echo "Finished! Amd drivers are now installed."