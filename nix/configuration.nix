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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    windowManager.openbox.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${myuser}" = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ git ];
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  home-manager
  vim
  wget
  htop
  powertop
  sshpass
  python311
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
