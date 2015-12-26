{ config, pkgs, ... }:
let
  bootUUID = "AE75-9210";
  poolUUID = "4ddb1208-d1c9-4e72-bfdc-da4a439ed6d6";
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
