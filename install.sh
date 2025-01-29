#!/usr/bin/env bash
set -e

DISK=nvme0n1
# TODO usar DISK
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /home/nixos/nixos/disko.nix --arg device '"/dev/nvme0n1"'