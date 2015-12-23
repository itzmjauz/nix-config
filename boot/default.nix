{ config, pkgs, ... }:
let
  bootUUID = "F617-7693";
  poolUUID = "971fbcc3-a104-42d0-93ad-566f21234b53";
in
{
  imports = [ ./systemd-zfs-generator ./gummibootr ];

  networking.hostId = "a8c09ec5";

  fileSystems = {
    "/" = {
      device = "storage/nixos";
      fsType = "zfs";
      options = "zfsutil";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/${bootUUID}";
      fsType = "vfat";
    };

    "/tmp" = {
      device = "tmp";
      fsType = "tmpfs";
    };
  };

  boot = {
    loader.gummibootr = {
      enable = true;
      timeout = 0;
    };

    supportedFilesystems = [ "zfs" ];
    initrd.luks.devices = [{
      name = "${poolUUID}";
      device = "/dev/disk/by-uuid/${poolUUID}";
    }];
  };
}
