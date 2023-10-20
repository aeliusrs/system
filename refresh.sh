#!/usr/bin/env bash

# Refresh Home-manager
cp -f ./nix/home.nix ~/.config/home-manager/home.nix
home-manager switch
