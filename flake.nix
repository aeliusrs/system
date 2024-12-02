{
  description = "NixOs configuration";

  inputs = {
    nixpkgs-prev.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-next.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # helpers
    flake-compat = {
      url = "github:edolstra/flake-compat";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      ...
    }@inputs:
    let
      lib = import ./nix/lib inputs;
      inherit (lib)
        recursiveMergeAttrs
        # mkRunCmd
        ;
    in
    recursiveMergeAttrs [
      # Default overlay output of this flake, handy to refer to it in other outputs
      {
        inherit lib;
        overlays.default = import ./nix/overlays { flake = self; };
      }
      # Configurations go here
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
            ];
            specialArgs = {
              flake = self;
            };
          };
          # import other config here ...
        }; # End of nixosConfigurations
      }

      # # Commands
      # (mkRunCmd {
      #   name = "linter";
      #   deps = pkgs: with pkgs; [ statix ];
      #   text = "statix fix -i hardware-configuration.nix";
      # })

      # Devshells, formatter, checks, etc.
      # This is like a for loop that runs for each system
      (flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
          };
        in
        {
          # This is what runs when you run `nix develop`
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              fd
              nil
              nixfmt-rfc-style
              ripgrep
              statix
            ];
          };
          # This is what runs when you run `nix flake check`
          checks = import ./checks.nix { inherit pkgs; };
          # This is what runs when you run `nix fmt`
          formatter = pkgs.nixfmt-rfc-style;
          # this is a useful output, it's a package set with all the packages and your overlays
          legacyPackages = pkgs;
        }
      ))

    ]; # End of recursiveMergeAttrs
  ## Output for the flake finishes here

  # Nix config for the flake
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    ## Add a github access token if you run into rate limiting issues
    # access-tokens = [
    #   "github.com=github_pat_1......"
    # ];
  };

}
