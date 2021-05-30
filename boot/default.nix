{ config, pkgs, ... }:
let
  bootUUID = "9408-6ED4";
  poolUUID = "aeb5b753-76ac-4170-a98b-b35b7b420ab5";
in
{
  imports = let
    pkgs = import <nixpkgs> { config.packageOverrides = import ../pkgs; };
  in builtins.map (drv: drv.outPath) [ ];

  networking.hostId = "a8c09ec5";

  fileSystems = {
    "/" = {
      device = "storage/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
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
    loader = {
      systemd-boot.enable = true;
      timeout = 0;
    };

    supportedFilesystems = [ "zfs" ];
    #initrd.luks.devices= {
      #  name = "${poolUUID}";
      #device = "/dev/disk/by-uuid/${poolUUID}";
      #};
    initrd.luks.devices."${poolUUID}".device = "/dev/disk/by-uuid/${poolUUID}";
  };
}
