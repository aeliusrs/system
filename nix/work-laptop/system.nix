{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    initrd = {
      systemd.enable = lib.mkDefault true;
    };

    kernel.sysctl = {
      # Enable Magic keys
      "kernel.sysrq" = 1;
      # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      "vm.swappiness" = lib.mkForce 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    # Enable NTFS support
    supportedFilesystems = [ "ntfs" ];

    tmp = {
      # Mount /tmp using tmpfs for performance
      useTmpfs = lib.mkDefault true;
      # If not using above, at least clean /tmp on each boot
      cleanOnBoot = lib.mkDefault true;
    };
  };

  # Enable firmware-linux-nonfree
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  services = {
    cron.enable = true;

    # Trim SSD weekly
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # Decrease journal size
    journald.extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  systemd = {
    # enable systemd-networkd
    network.enable = true;
    # Reduce default service stop timeouts for faster shutdown
    extraConfig = ''
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=5s
    '';
    # systemd's out-of-memory daemon
    oomd = {
      enableRootSlice = true;
      enableUserSlices = true;
    };
  };

  system.switch = {
    # enable switch-to-configuration-ng
    enable = lib.mkDefault false;
    enableNg = lib.mkDefault true;
  };


  # nixos/modules/misc/version.nix
  users.motd = ''Welcome to '${config.networking.hostName}' running NixOS ${config.system.nixos.version}!'';

  # Enable zram to have better memory management
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 50;
  };
}
