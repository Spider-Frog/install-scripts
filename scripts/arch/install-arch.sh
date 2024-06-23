#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Arch Linux Install script by SpiderFrog"

while true; do
    read -p "This script will install Arch Linux, Do you wan't to continue? (yes/no): " yesno
    case $yesno in
        [Yy]* )
            # Install grub with efi
            break
        ;;
        [Nn]* )
            exit
        ;;
        * ) echo "Answer either yes or no!";;
    esac
done

read -p 'Enter your mounted drive folder (default=/mnt): ' mnt_folder
mnt_folder=${mnt_folder:-/mnt}

echo ""

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
            echo "Error: Could not determine the CPU vendor."
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

yes | pacstrap -K $mnt_folder base base-devel linux linux-firmware\
                 btrfs-progs grub efibootmgr grub-btrfs\
                 inotify-tools timeshift $cpu_package\
                 pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber reflector\
                 zsh zsh-completions zsh-autosuggestions\
                 openssh man sudo git nano networkmanager

echo "Done."
echo ""
echo "Generating fstab..."

genfstab -U $mnt_folder >> "${mnt_folder}/etc/fstab"

echo "Done."
echo ""
echo "Entering '${mnt_folder}' environment."
echo ""

arch-chroot $mnt_folder

while true; do
    read -p "Do you want to setup locale?  (yes/no): " yesno
    case $yesno in
        [Yy]* )

            localetime_file="/etc/localtime"
            locale_gen_file="/etc/locale.gen"
            locale_conf_file="/etc/locale.conf"
            keymap_file="/etc/vconsole.conf"

            hostname_file="/etc/hostname"
            hosts_file="/etc/hosts"

            # Prompt user for configuration
            echo "Setting up system locale and host configuration"

            read -p 'Enter your locale (default=UTC): ' localetime
            localetime=${localetime:-UTC}

            read -p 'Enter your locale (default=en_US.UTF-8): ' locale
            locale=${locale:-en_US.UTF-8}

            read -p 'Enter your keymap (default=us): ' keymap
            keymap=${keymap:-us}

            echo ""

            # Setup timezone
            ln -sf "/usr/share/zoneinfo/${localetime}" /etc/localtime

            # Sync the time to the hardware clock
            hwclock --systohc

            # Generate locales
            sed -i "/^# *${locale} UTF-8/s/^# *//" $locale_gen_file
            locale-gen

            # Setup locale & keymap
            echo "LANG=en_US.UTF-8" > $locale_conf_file
            echo "KEYMAP=us" > $keymap_file

            echo "Done."
            echo ""
            echo "Setting up host configuration..."

            read -p 'Enter the hostname: ' hostname

            # Setup hostname
            echo $hostname > $hostname_file

            # Setup hosts file
            echo "127.0.0.1 localhost
            ::1 localhost
            127.0.1.1 Arch" >> $hosts_file

            echo "Done."
            break
        ;;
        [Nn]* )
            break
        ;;
        * ) echo "Answer either yes or no!";;
    esac
done

echo ""

while true; do
    read -p "Do you want to install grub?  (yes/no): " yesno
    case $yesno in
        [Yy]* )
            # Install grub with efi
            echo ""
            echo "Installing grub..."

            grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB

            # Generate the grub configuration
            grub-mkconfig -o /boot/grub/grub.cfg

            echo "Done."
            break
        ;;
        [Nn]* )
            break
        ;;
        * ) echo "Answer either yes or no!";;
    esac
done

echo ""
echo "Enabling systemd services..."

systemctl enable NetworkManager

echo "Done."
echo ""
echo "Finished! Arch is now installed."
echo "Please configure your root password & users."
echo "Then exit the chroot environemnt with 'exit'"
echo "Unmount everything with 'umount -R ${mnt_folder}'"
echo "Then reboot your system. And Arch Linux should boot up!"