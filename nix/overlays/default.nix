{ flake }:
final: prev:

let
  inherit (flake) outputs inputs;
in
outputs.lib.recursiveMergeAttrs [

  # (inputs.nixpkgs.overlays.default final prev)
  (import ./cloudflare-warp final prev)

  {
    # Add insults to the injury
    sudo = prev.sudo.override { withInsults = true; };

    # Use the latest version of sshping
    sshping = prev.sshping.overrideAttrs {
      version = "0.1.5alpha";
      src = prev.fetchFromGitHub {
        owner = "spook";
        repo = "sshping";
        rev = "master";
        sha256 = "sha256-20q264BFL5GqivrDf7amYCaWhgM8SbRzus1DYUmbP7w=";
      };
    };

    nix-cleanup = prev.callPackage ../nix-packages/nix-cleanup { };

    nixos-cleanup = prev.callPackage ../nix-packages/nix-cleanup { isNixOS = true; };

    nix-whereis = prev.callPackage ../nix-packages/nix-whereis { };

    run-bg-alias =
      name: command: prev.callPackage ../nix-packages/run-bg-alias { inherit name command; };

    # headscale overlayed from the flake (comes handy sometimes)
    # inherit (inputs.headscale.nix-packages."${final.system}") headscale;

    # deploy-rs from the flake
    # inherit (inputs.deploy-rs.nix-packages."${final.system}") deploy-rs;

    # HACK: Overlay the Vagrant package from stable Nixpkgs
    # until https://github.com/NixOS/nixpkgs/issues/348938 is resolved
    vagrant =
      let
        pkgs = import inputs.nixpkgs-prev {
          inherit (final) system;
          config.allowUnfree = true;
        };
      in
      pkgs.vagrant;

    # HACK: Related issue: https://github.com/NixOS/nixpkgs/issues/356734
    rustdesk-flutter =
      let
        pkgs = import inputs.nixpkgs-prev {
          inherit (final) system;
        };
      in
      pkgs.rustdesk-flutter;

    # HACK: Overlay to fix the broken onedrive service
    onedrive = prev.onedrive.overrideAttrs (
      finalAttrs: previousAttrs: {
        postInstall =
          previousAttrs.postInstall
          + ''
            substituteInPlace $out/lib/systemd/user/onedrive.service \
              --replace '/usr/bin/sleep' \
              '${final.coreutils}/bin/sleep'
          '';
      }
    );
  }
]
