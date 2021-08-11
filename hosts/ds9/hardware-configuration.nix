# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot.initrd.availableKernelModules = [ "r8169" "ahci" "vfio-pci" "xhci_pci" "ehci_pci" "nvme" "usbhid" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = "performance";

  services.zfs.autoScrub.enable = true;
  ragon.system.fs = {
    enable = true;
    mediadata = false;
    swap = false;
    persistentSnapshot = false;
    nix = "rpool/content/local/nix";
    varlog = "rpool/content/local/journal";
    persistent = "rpool/content/safe/persist";
    arcSize = 8;
  };
  services.syncoid.enable = false; # TODO setup offsite backups

  services.sanoid.datasets."rpool/content/safe".recursive = true;
  services.sanoid.datasets."rpool/content/local/backups" = { };
  services.sanoid.enable = true;

  swapDevices = [ { device = "/dev/disk/by-id/nvme-eui.000000000000000100a075202c247839-part1"; randomEncryption = true; } ];
  fileSystems."/boot".device = "/dev/disk/by-uuid/149F-23AA";

  fileSystems."/data" = {
    device = "rpool/content/safe/data";
    fsType = "zfs";
  };
  fileSystems."/data/media" = {
    device = "rpool/content/safe/data/media";
    fsType = "zfs";
  };
  fileSystems."/backups" = {
    device = "rpool/content/local/backups";
    fsType = "zfs";
  };

}
