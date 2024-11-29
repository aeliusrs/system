{
  description = "NixOs configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-next.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, ... }:
    {
      nixosConfigurations = {

        #WorkLaptop
        arrow = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/work-laptop/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aeliusrs = import ./nix/work-laptop/home.nix;
            }
            {
              nixpkgs.overlays = [
                (final: prev: {
                  sops =
                    let
                      pkgs = import inputs.nixpkgs-next {
                        inherit (final) system;
                      };
                    in
                    pkgs.sops;
                })
              ];
            }
          ];
          specialArgs = {
            flake = self;
          };
        };

        # import other config here ...

      };
    };
}
