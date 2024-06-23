#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Installing Arch..."

pacman-key --init

pacman-key --populate archlinux

# Function to check the CPU vendor
get_cpu_vendor() {
    # Check if the /proc/cpuinfo file exists
    if [ -f /proc/cpuinfo ]; then
        # Extract the vendor_id from /proc/cpuinfo
        vendor=$(grep -m 1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
        
        if [ -z "$vendor" ]; then
            echo "Could not determine the CPU vendor."
            exit 1
        else
            echo $vendor
        fi
    else
        echo "/proc/cpuinfo file not found."
        exit 1
    fi
}

cpu_vendor=$(get_cpu_vendor)

# Determine CPU vendor for microcode package
if [ "${cpu_vendor}" == "AuthenticAMD" ]; then
  cpu_package = 'amd-ucode'
else
  cpu_package = 'intel-ucode'
fi

pacstrap -K /mnt base base-devel linux linux-firmware\
                 btrfs-progs grub efibootmgr grub-btrfs\
                 inotify-tools timeshift $cpu_package\
                 pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber reflector\
                 zsh zsh-completions zsh-autosuggestions\
                 openssh man sudo git nano networkmanager

echo "Done."
echo ""
echo "Generating fstab..."

genfstab -U /mnt >> /mnt/etc/fstab

echo "Done."
echo ""
echo "Finished! Arch is now installed."
echo "Please reboot your system."