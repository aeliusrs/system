{
  description = "NixOs configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { nixpkgs, ... }:
    {
      nixosConfigurations = {

        #WorkLaptop
        work-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/work-laptop/configuration.nix
          ];
        };

        # arrow = nixpkgs.lib.nixosSystem {
          # system = "x86_64-linux";
          # modules = [
            # ./nix/work-laptop/configuration.nix
          # ];
        # };

      };
    };
}
