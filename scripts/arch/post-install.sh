#!/bin/bash
# Created by SpiderFrog https://github.com/Spider-Frog/install-scripts

echo "Arch Linux post-install script by SpiderFrog"

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

            read -p 'Enter your timezone (default=UTC): ' localetime
            localetime=${localetime:-UTC}

            read -p 'Enter your locale (default=en_US.UTF-8): ' locale
            locale=${locale:-en_US.UTF-8}

            read -p 'Enter your keymap (default=us): ' keymap
            keymap=${keymap:-us}

            echo ""

            # Setup timezone
            ln -sf "/usr/share/zoneinfo/${localetime}" $localetime_file

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
echo "Finished setting up your Arch Linux system!"
echo "Steps left to do:"
echo "  - Configure your root password & users."
echo "  - Exit the chroot environment,"
echo "  - Unmount partitions,"
echo "  - Reboot your system."