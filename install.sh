#!/usr/bin/env bash
set -e

DISK=nvme0n1
HOST=afroframe
# TODO usar DISK
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /home/nixos/nixos/disko.nix --arg device '"/dev/nvme0n1"'

# mkdir /mnt/etc
# mv /home/nixos/nixos /mnt/etc/nixos
# cp -r /mnt/etc/nixos /mnt/persist/nixos

nixos-install --root /mnt --flake /mnt/etc/nixos#afroframe --show-trace