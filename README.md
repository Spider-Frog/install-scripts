# install-scripts
A collection of scripts to quickly install Linux systems

Created and maintained by [SpiderFrog](https://github.com/Spider-Frog)

## Download & run scripts
```shell
# Downloads scripts
git clone https://github.com/Spider-Frog/install-scripts.git

# Make sure to allow script execution
chmod +x -R ./install-scripts

# Usage
./install-scripts/<chapter>/<script>.sh

# Example
./install-scripts/arch/install-arch.sh
```

## Scripts

### Arch

All these scripts are for the Arch Linux distro and setup various system settings and packages automatically.

```install-arch.sh```
For installing Arch Linux in a live boot environment.
Handles everything from installing packages, setting up locales and Grub.

```install-amd.sh```
For installing Amd drivers.

```install-gnome.sh```
For installing Gnome with sensible defaults programs, icons, theme and Pamac.

```setup-btrfs.sh```
Enabling Btrfs with automatic snapshots when using Pacman.