#!/usr/bin/env bash

mkdir -p ~/.config/home-manager/
cp ./nix/home.nix ~/.config/home-manager/home.nix

sudo cp -f ./nix/configuration.nix /etc/nixos/configuration.nix

sudo nixos-rebuild switch && home-manager switch

reboot
