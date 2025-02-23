#!/usr/bin/env bash
set -e

pushd ~/nixos/

# Early return if no changes were detected (thanks @singiamtel!)
# if git diff --quiet '*.nix'; then
#     echo "No changes detected, exiting."
#     popd
#     exit 0
# fi

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Solo para solicitar el sudo
sudo id &>/dev/null
echo "NixOS Rebuilding..."

# update flake inputs
nix flake update

# Rebuild, output simplified errors, log trackebacks
# sudo nixos-rebuild switch --flake /home/moy/nixos &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
sudo nixos-rebuild switch --flake /home/moy/nixos

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"
git push

# Back to where you were
popd

# Notify all OK!
# notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
