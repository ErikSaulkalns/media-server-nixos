#!/bin/bash

# Check if the script is run with sudo/root privileges
if [ "$UID" -ne 0 ]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

DISK_NAME="vda"

# Fetch configuration
curl https://raw.githubusercontent.com/ErikSaulkalns/media-server-nixos/main/disko/hybrid.nix -o /tmp/disko-config.nix || {
    echo "Failed to fetch the configuration.";
    exit 1;
}

# Use the disko to partition the drive
nix run github:nix-community/disko -- --mode disko /tmp/disko-config.nix --arg disks "[ \"/dev/$DISK_NAME\" ]"
