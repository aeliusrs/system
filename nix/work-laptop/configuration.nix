{ config, pkgs, ... }:
let
   myuser = "aeliusrs";
#   edk2-aarch64 = pkgs.callPackage "/etc/nixos/edk2-aarch64.nix" {};
in
{
  imports = [
      ./system.nix
      ./hardware-configuration.nix
    ];

  system.stateVersion = "24.05";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # To be able to cross compile to ARM

# boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
#   nixpkgs.overlays = [ 
#      (final: prev: {
#        OVMF = prev.OVMF.overrideAttrs (oldAttrs: {
#          postInstall = (oldAttrs.postInstall or "") + ''
#            mkdir -vp $fd/FV
#            cp -v ${edk2-aarch64}/aarch64/QEMU_CODE.fd $fd/FV/AAVMF_CODE.fd
#            cp -v ${edk2-aarch64}/aarch64/QEMU_VARS.fd $fd/FV/AAVMF_VARS.fd
#          '';
#        });
#      })
#    ];


  # Decrypt got a GUI
  boot.initrd.systemd.enable = true; #authorize plymouth in stage 1
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
  boot.kernelParams = ["quiet"];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };


  # Hostname
  networking.hostName = "arrow"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true; 
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  networking.wireguard.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

#  networking.extraHosts = ''
#    192.168.3.150 bastion-dev.n-hop.com registry.bastion-dev.n-hop.com sources.bastion-dev.n-hop.com
#  '';

  services.resolved.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_HK.UTF-8";
    LC_IDENTIFICATION = "en_HK.UTF-8";
    LC_MEASUREMENT = "en_HK.UTF-8";
    LC_MONETARY = "en_HK.UTF-8";
    LC_NAME = "en_HK.UTF-8";
    LC_NUMERIC = "en_HK.UTF-8";
    LC_PAPER = "en_HK.UTF-8";
    LC_TELEPHONE = "en_HK.UTF-8";
    LC_TIME = "en_HK.UTF-8";
  };

  # Configure X11
  services.xserver = {
    enable = true;                       # enable X11
    windowManager.openbox.enable = true; # enable Openbox
    xkb.layout = "us";
    xkb.variant = "";
  };


  # Configure LightDM themes
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "Adwaita-dark";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${myuser}" = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "libvirtd"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # activate man 3 pages
  documentation.dev.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    vim
    wget
    htop
    sshpass
    ssh-agents
    file
    direnv
    python311
    powertop            # Intel Base power analyze
    nixos-bgrt-plymouth # nice theme for plymouth
    lightdm-gtk-greeter # nice theme for lightDM
    home-manager        # a Nix Dotfiles manager for users
    light               # to manage brightness
    alsa-utils          # to manage audio card
    pipewire            # to manage sound
    udisks              # to manage USB automount
    libvirt             # to manage VM
    qemu_full           # to have VM
    guestfs-tools       # to have better integration with vagrant
    podman              # to have containers
    podman-compose      # to do containers composition
    pciutils            # lspci
    usbutils            # lsusb
    dnsutils            # nslookup
    via                 # keyboard configurator
    vial                # keyboard configurator
    openssl             # to manipulate ssl
    wireguard-tools     # tools to use wireguard
    cloudflare-warp     # Cloudflare warp tools to esc the gfw
    #gparted             # Partition tool
  #  lldpd		# link layer discovery proto daemon 
  ];

  # LLPD
  #services.lldpd.enable = true;

  # Cloudflare
  systemd.packages = with pkgs; [ cloudflare-warp ]; # for warp-cli
  systemd.targets.multi-user.wants = [ "warp-svc.service" ];
  nixpkgs.overlays = [ (import ./warp-overlay.nix) ];

  # BPFTune
  services.bpftune.enable = true;

  # Fix Shell for home-manager
  environment.shellInit = ''
    export  NIXPATH="/nix/var/nix/profiles/per-user/$USER/channels:nixos-config=/etc/nixos/configuration.nix"
  '';

  # Path
  system.activationScripts.makeDir = with pkgs; lib.stringAfter [ "var" ] ''
    mkdir -p /opt

    mkdir -p /home/${myuser}/Pictures /home/${myuser}/Videos /home/${myuser}/Music
    mkdir -p /home/${myuser}/Desktop /home/${myuser}/Documents /home/${myuser}/Downloads
    mkdir -p /home/${myuser}/.local/state/home-manager/profiles /nix/var/nix/profiles/per-user/${myuser}
    chown -R 1000:users /home/${myuser}
  '';

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      ClientAliveCountMax = 1;
      LogLevel = "VERBOSE";
      MaxAuthTries = 3;
      TCPKeepAlive = "no";
      MaxSessions = 2;
    };
#    extraConfig = ''
#      CanonicalizeHostname yes
#    '';
  };


  # Activate pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # to support Pavucontrol GUI
    jack.enable = true;  # to support DAW
  };

  # automount Device
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # activate libvirt
  virtualisation = {
    libvirtd = { 
      enable = true;
      qemu = {
       ovmf = {
        enable = true;
	packages = [ pkgs.OVMFFull.fd pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd ];
        };
      };
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    containers.registries.insecure = [];
  };

  # activate zsh
  programs.zsh.enable = true;

  # start ssh agents accross terms
  programs.ssh.startAgent = true;

  # activate light
  programs.light.enable = true;

  # activate zsh
  programs.dconf.enable = true; #so virt-manager can remember stuff

  # activate bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;


  services.udev.packages = with pkgs; [
    via
    vial
  ];

  # to let qmk access my non-root user
  hardware.keyboard.qmk.enable = true;

  nix = {
    package = pkgs.nixVersions.latest;

    gc = {
      automatic = true;
      dates = "weekly";
#      options = "--delete-older-than 7d";
    };

    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
      auto-allocate-uids = true;
      use-cgroups = true;
      # max-jobs = 8; # limit the number of parallel jobs
      # flake-registry = ""; # disable global registry

      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        # Allows Nix to automatically pick UIDs for builds, rather than creating nixbld* user accounts
        "auto-allocate-uids"

        # Allows Nix to execute builds inside cgroups
        "cgroups"
        # "configurable-impure-env" 
        # "ca-derivations" 
      ];
    };
  };
}
