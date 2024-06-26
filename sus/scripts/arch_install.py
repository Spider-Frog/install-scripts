import subprocess
from utils import ask_bool, ask_str
import os, platform, subprocess, re


# https://stackoverflow.com/questions/4842448/getting-processor-information-in-python
def get_processor_name():
    if platform.system() == "Windows":
        return platform.processor()
    elif platform.system() == "Darwin":
        os.environ['PATH'] = os.environ['PATH'] + os.pathsep + '/usr/sbin'
        command ="sysctl -n machdep.cpu.brand_string"
        return subprocess.check_output(command).strip()
    elif platform.system() == "Linux":
        command = "cat /proc/cpuinfo"
        all_info = subprocess.check_output(command, shell=True).decode().strip()
        for line in all_info.split("\n"):
            if "model name" in line:
                return re.sub( ".*model name.*:", "", line,1)
    return ""


def run():
    if not ask_bool("This script will install Arch Linux, Do you wish to continue?"):
        exit()
    
    mnt_folder = ask_str("Enter mounted drive folder", default='/mnt', allow_none=False)
    
    packages = ['base', 'base-devel', 'linux', 'linux-firmware', 'networkmanager']
    
    match get_processor_name():
        case vendor if 'amd' in vendor.lower():
            packages.append('amd-ucode')
        case vendor if 'intel' in vendor.lower():
            packages.append('intel-ucode')
        case _:
            print("Failed to determine CPU vendor.")
            
    if ask_bool("Include Grub support?"):
        packages += ['grub', 'efibootmgr']
        
        if ask_bool("Include Btrfs support?"):
            packages += ['btrfs-progs', 'grub-btrfs', 'timeshift', 'inotify-tools']
            
    if ask_bool("Include Pipewire audio packages?"):
        packages += ['pipewire', 'pipewire-alsa', 'pipewire-pulse', 'pipewire-jack', 'wireplumber']
            
    match ask_str("Choose your shell, Leave empty for none", options=['bash', 'zsh'], allow_none=True):
        case 'bash':
            packages += ['bash', 'bash-completion']
        case 'zsh':
            packages += ['zsh', 'zsh-completions', 'zsh-syntax-highlighting', 'zsh-autosuggestions']
            
    match ask_str("Choose your editor, Leave empty for none", options=['vim', 'nano'], allow_none=True):
        case 'vim':
            packages += ['vim']
        case 'nano':
            packages += ['nano']
            
    if ask_bool("Include some basic packages? (openssh, sudo & git)"):
        packages += ['openssh', 'sudo', 'git']
    
    print()
    print("Package list:", ' '.join(packages))
    
    if not ask_bool(f"This script will install {len(packages)} packages inside the '{mnt_folder}' folder, Do you wish to continue?"):
        exit()
    
    print()
    print("Starting installation...")
    
    # Install commands
    try:
        subprocess.run(["pacman-key", "--init"], check=True)
        subprocess.run(["pacman-key", "--populate", "archlinux"], check=True)
        subprocess.run(["pacstrap", '-K', mnt_folder, *packages], check=True, text=True)
        
        print("Done")
    except subprocess.CalledProcessError:
        print("Something went wrong with installing Arch Linux, please check the error logs and try again.")


if __name__ == '__main__':
    run()
