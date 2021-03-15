# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "size=3G", "defaults", "mode=755" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/88cad3d1-2e42-495c-988f-377fa4fcd3b6";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/88cad3d1-2e42-495c-988f-377fa4fcd3b6";
      fsType = "btrfs";
      options = [ "subvol=var/log" ];
    };

  fileSystems."/persistent" =
    { device = "/dev/disk/by-uuid/88cad3d1-2e42-495c-988f-377fa4fcd3b6";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=persistent" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1259-3A7D";
      fsType = "vfat";
      options = [ "noauto" "x-systemd.automount" ];
    };

  swapDevices = [ ];

}
