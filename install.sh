#!/usr/bin/env bash

# Prepare system
sudo cp -f ./nix/configuration.nix /etc/nixos/configuration.nix
sudo nix-channel --update #needed to update some nixpath for the user
sudo nixos-rebuild switch

# Prepare Home-manager
home-manager init 
cp -f ./nix/home.nix ~/.config/home-manager/home.nix
home-manager switch

reboot
