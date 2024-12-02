{ self, flake-utils, ... }@inputs:

let
  inherit (flake-utils.lib) eachDefaultSystem mkApp;
in
{
  mkRunCmd =
    {
      name,
      text,
      deps ? pkgs: [ ],
    }:
    eachDefaultSystem (
      system:
      let
        pkgs = self.outputs.legacyPackages.${system};
      in
      {
        apps.${name} = mkApp {
          drv = pkgs.writeShellApplication {
            inherit name text;
            runtimeInputs = deps pkgs;
          };
        };
      }
    );

  mkNixOSConfig =
    {
      hostname,
      system ? null, # get from hardware-configuration.nix by default
      nixpkgs ? inputs.nixpkgs,
      extraModules ? [ ],
    }:
    let
      inherit (self.outputs.nixosConfigurations.${hostname}) config pkgs;
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (
            { lib, ... }:
            {
              networking.hostName = lib.mkDefault hostname;
            }
          )
          ../hosts/${hostname}
        ] ++ extraModules;
        specialArgs = {
          flake = self;
          libEx = self.outputs.lib;
        };
      };

      apps.${pkgs.system} = {
        "nixosActivations/${hostname}" = mkApp {
          drv = config.system.build.toplevel;
          exePath = "/activate";
        };

        "nixosVMs/${hostname}" = mkApp {
          drv = config.system.build.vm;
          exePath = "/bin/run-${hostname}-vm";
        };
      };
    };

  # https://github.com/nix-community/home-manager/issues/1510
  mkHomeConfig =
    {
      hostname,
      username ? "thiagoko",
      homePath ? "/home",
      homeDirectory ? "${homePath}/${username}",
      configuration ? ../home-manager,
      deviceType ? "desktop",
      extraModules ? [ ],
      system ? "x86_64-linux",
      home-manager ? inputs.home-manager,
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion ? "24.05",
    }:
    {
      homeConfigurations.${hostname} = home-manager.lib.homeManagerConfiguration {
        pkgs = self.outputs.legacyPackages.${system};
        modules = [
          (
            { ... }:
            {
              home = {
                inherit username homeDirectory stateVersion;
              };
              imports = [ configuration ];
            }
          )
        ] ++ extraModules;
        extraSpecialArgs = {
          flake = self;
          libEx = self.outputs.lib;
          osConfig = {
            device.type = deviceType;
            mainUser.username = username;
          };
        };
      };

      apps.${system}."homeActivations/${hostname}" = mkApp {
        drv = self.outputs.homeConfigurations.${hostname}.activationPackage;
        exePath = "/activate";
      };
    };
}
