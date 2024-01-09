nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
nix-channel --update

As the root user, build your system:

# THIS ---
nixos-rebuild --upgrade boot

# ---- ---
Reboot to enter your newly-built NixOS.

If things go wrong you can reboot, select the previous generation,
use nix-channel to add the old channel,
and then nixos-rebuild boot to make the working generation the default;
I think it's more reliable to rebuild than to use nixos-rebuild --rollback.


