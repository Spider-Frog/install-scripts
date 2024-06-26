#!/usr/bin/python
import argparse
import subprocess

parser = argparse.ArgumentParser()

parser.add_argument("script", type=str)

args = parser.parse_args()

print()
print("SpiderFrog Utilities Scripts (SUS)")
print()

match args.script:
    case 'arch-install':
        from scripts.arch_install import run

        run()
    case 'arch-post-install':
        print("Running arch post install script...")
    case 'arch-install-amd':
        print("Running arch amd install script...")
    case 'arch-install-gnome':
        print("Running arch gnome install script...")
    case 'arch-setup-btrfs':
        print("Running arch btrfs install script...")
    case _:
        print(f"Error: Script '{args.script}' not found.")
        print()
        print("Please choose one of the following scripts:")
        print("  - arch-install, For installing Arch Linux in a live usb environment.")
        print("  - arch-post-install, For installing Arch Linux in a chroot environment.")
        print("  - arch-install-amd, For installing AMD drivers on Arch Linux.")
        print("  - arch-install-gnome, For installing Gnome on Arch Linux.")
        print("  - arch-setup-btrfs, For setting up Btrfs support on Arch Linux.")


def test():
    pass