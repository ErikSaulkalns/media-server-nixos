#!/bin/bash
set -e

# Check if the script is run with sudo/root privileges
if [ "$UID" -ne 0 ]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Install Git if not installed
if ! command -v git &> /dev/null; then
    nix-env -iA nixos.git
fi

# Clone the entire project
git clone https://github.com/ErikSaulkalns/media-server-nixos.git /tmp/media-server-nixos

# Use disko to partition the drive
nix run --extra-experimental-features 'nix-command flakes' github:nix-community/disko -- --mode disko /tmp/media-server-nixos/disko-config.nix

# Generate NixOS config without filesystems
nixos-generate-config --no-filesystems --root /mnt

# Move configurations into place
mv /tmp/media-server-nixos/*.nix /mnt/etc/nixos/

# Install NixOS
nixos-install --no-root-password || {
    echo "NixOS installation failed.";
    exit 1;
}

# Prompt to change password for the nixos user
echo "Enter password for nixos user"
chroot /mnt /run/current-system/sw/bin/passwd nixos

echo "Installation completed successfully. REBOOT NOW!"
