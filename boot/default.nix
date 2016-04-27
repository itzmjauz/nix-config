{ config, pkgs, ... }:
let
  bootUUID = "AE75-9210";
  poolUUID = "4ddb1208-d1c9-4e72-bfdc-da4a439ed6d6";
in
{
  imports = let
    pkgs = import <nixpkgs> {};
    systemd-zfs-generator = pkgs.fetchcode {
      repo = "systemd-zfs-generator";
      rev = "80b3a2daf23a0d9abd2e1b1642d1064a7f875397";
      sha256 = "0qm7cvd91pj4q7v7yjzr2wqqdnzm6iqkjipd63k4676hjcmlkmfy";
    };
    gummibootr = pkgs.fetchcode {
      repo = "gummibootr";
      rev = "826cba3609459deeef4c34f126135118e79b2c55";
      sha256 = "0bjjc8s2ss2wh260hqzimba6swy0jw0szpj91pv3sq7dzbpradsm";
    };
  in builtins.map (drv: drv.outPath) [ systemd-zfs-generator gummibootr ];

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
