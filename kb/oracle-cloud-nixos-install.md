
# Install NixOS on Oracle Cloud over Ubuntu 18.04
```bash
# install useful tools
sudo apt-get update
sudo apt-get install --no-install-recommends -y nano mc git

# prepare /boot
sudo umount /boot/efi
sudo mv /boot /boot.bak
sudo mkdir /boot/
sudo mount /dev/sda15 /boot
sudo mv /boot/* /boot.bak/efi/

# use swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# install nix
curl https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://nixos.org/channels/nixos-20.03 nixpkgs
# nix-channel --add https://github.com/rycee/home-manager/archive/release-20.03.tar.gz home-manager
nix-channel --update

# install nixos-generate-config and nixos-install
nix-env -iE "_: with import <nixpkgs/nixos> { configuration = {}; }; with config.system.build; [ nixos-generate-config nixos-install ]"

# generate config
sudo `which nixos-generate-config` --root /

# remove lxc mounts
sudo nano /etc/nixos/hardware-configuration.nix
# set hostname, add users and ssh-keys, enable openssh
sudo nano /etc/nixos/configuration.nix

# build config
nix-env -p /nix/var/nix/profiles/system -f '<nixpkgs/nixos>' -I nixos-config=/etc/nixos/configuration.nix -iA system

# prepare target
sudo chown -R 0.0 /nix
sudo touch /etc/NIXOS
sudo touch /etc/NIXOS_LUSTRATE
echo etc/nixos | sudo tee -a /etc/NIXOS_LUSTRATE

# install NixOS
sudo NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot

sudo reboot
```

# Recommended configuration options
```nix
{
  # Oracle Cloud uses EFI boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel cmdline from Ubuntu config
  boot.kernelParams = [
    "console=ttyS0"
    "console=tty1"
    "nvme.shutdown_timeout=10"
    "libiscsi.debug_libiscsi_eh=1"
  ];

  # Load graphics driver in stage 1
  boot.initrd.kernelModules = [ "bochs_drm" ];
  
  # Get network configuration from DHCP
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  # swap file is recommended
  swapDevices = [
    {
      device = "/swapfile";
      priority = 0;
    }
  ];
}
```

## Repartitioning target system from kexec image
Create `kexec.nix` file with following contents (do not add any packages to `environment.systemPackages` or it won't boot on 1GB system):
```nix
{ config, pkgs, ... }:
{
  imports = [
    # this will work only under qemu, uncomment next line for full image
    # <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix>
    <nixpkgs/nixos/modules/installer/netboot/netboot.nix>
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  # stripped down version of https://github.com/cleverca22/nix-tests/tree/master/kexec
  system.build = rec {
    image = pkgs.runCommand "image" { buildInputs = [ pkgs.nukeReferences ]; } ''
      mkdir $out
      cp ${config.system.build.kernel}/bzImage $out/kernel
      cp ${config.system.build.netbootRamdisk}/initrd $out/initrd
      nuke-refs $out/kernel
    '';
    kexec_script = pkgs.writeTextFile {
      executable = true;
      name = "kexec-nixos";
      text = ''
        #!${pkgs.stdenv.shell}
        set -e
        ${pkgs.kexectools}/bin/kexec -l ${image}/kernel --initrd=${image}/initrd --append="init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}"
        sync
        echo "executing kernel, filesystems will be improperly umounted"
        ${pkgs.kexectools}/bin/kexec -e
      '';
    };
    kexec_tarball = pkgs.callPackage <nixpkgs/nixos/lib/make-system-tarball.nix> {
      storeContents = [
        {
          object = config.system.build.kexec_script;
          symlink = "/kexec_nixos";
        }
      ];
      contents = [ ];
    };
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" ];
  boot.kernelParams = [
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
    "console=ttyS0" # enable serial console
    "console=tty1"
  ];
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  environment.systemPackages = with pkgs; [ cryptsetup ];
  environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

  networking.hostName = "kexec";

  services.mingetty.autologinUser = "root";
  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    # add your ssh key here
    "ssh-ed25519 ...."
  ];
}
```

Build kexec image (you'll need nix/NixOS installed on your machine):
```bash
nix-build '<nixpkgs/nixos>' -A config.system.build.kexec_tarball -I nixos-config=./kexec.nix
```

Copy tarball to remote machine using `scp` and reboot into kexec image:
```bash
scp result/tarball/nixos-system-x86_64-linux.tar.xz ubuntu@somehost:/tmp/
ssh ubuntu@somehost -t bash -c 'cd / && sudo tar xf /tmp/nixos-system-x86_64-linux.tar.xz && sudo /kexec_nixos'
# wait for machine to boot and then connect
ssh root@somehost
```

Repartition your drive, format, mount file systems, create swap(file) and activate it as soon as possible. Check [manual](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning) for more info.
