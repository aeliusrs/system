#Flake is an experimental features pushed on the community by nix creator

to build a flake you can use the following
```bash
nixos-rebuild switch --flake /path/to/flake
```

ensure you have activated flake in your nix config:
```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

you can create a flake file in a directory with
```bash
nix flake init
```

to update a flake simply run:
```bash
nix flake update
```
