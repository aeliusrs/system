#!/usr/bin/env bash

# download the nix install script
curl -L https://nixos.org/nix/install > nix-install.sh

# run the multi user installation script
sudo sh nix-install.sh --daemon --yes

# refresh shell so nix env variables are present
source /etc/profile.d/nix.sh

# install home-manager
nix-env -iA nixpkgs.home-manager

### Uncomment if needed
# init home manager
# home-manager init

rm -f ~/nix-install.sh || :
