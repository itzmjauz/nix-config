{ config, pkgs, ... }:
let
  bootUUID = "AE75-9210";
  poolUUID = "4ddb1208-d1c9-4e72-bfdc-da4a439ed6d6";
in
{
  imports = let
    pkgs = import <nixpkgs> {};
    systemd-zfs-generator = pkgs.fetchgit {
      url = "https://code.nathan7.eu/nathan7/systemd-zfs-generator";
      rev = "80b3a2daf23a0d9abd2e1b1642d1064a7f875397";
      sha256 = "0qm7cvd91pj4q7v7yjzr2wqqdnzm6iqkjipd63k4676hjcmlkmfy";
    };
    gummibootr = pkgs.fetchgit {
      url = "https://code.nathan7.eu/nathan7/gummibootr";
      rev = "0e48da9fb9a7370f016f67a0c829da8ff45fe224";
      sha256 = "1i3a52gz9yyc17gmmrhbcz995xzczafsgkyczw751zdhylafcdmr";
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
