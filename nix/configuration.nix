{ config, pkgs, ... }:
let
  myuser = "aeliusrs";
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  networking.hostName = "koi"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true; 
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    layout = "us";
    xkbVariant = "";
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    powertop            # Intel Base power analyze
    sshpass
    python311
    nixos-bgrt-plymouth # nice theme for plymouth 
    lightdm-gtk-greeter # nice theme for lightDM
    home-manager        # a Nix Dotfiles manager for users
    light               # to manage brightness
    alsa-utils          # to manage audio card
    pipewire            # to manage sound
    udisks              # to manage USB automount
    libvirt             # to manage VM
    qemu_full           # to have VM
    podman              # to have containers
    podman-compose      # to do containers composition
  ];


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
  services.openssh.enable = true;
  services.openssh.settings = {
    ClientAliveCountMax = 1;
    LogLevel = "VERBOSE";
    MaxAuthTries = 3;
    TCPKeepAlive = "no";
    MaxSessions = 2;
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
  };

  # activate zsh
  programs.zsh.enable = true;

  # activate light
  programs.light.enable = true;

  # activate bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
}
