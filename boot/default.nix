{ config, pkgs, ... }:
let
  bootUUID = "9408-6ED4";
  poolUUID = "aeb5b753-76ac-4170-a98b-b35b7b420ab5";
in
{
  imports = let
    pkgs = import <nixpkgs> { config.packageOverrides = import ../pkgs; };
    systemd-zfs-generator = pkgs.fetchgit {
      url = "https://code.nathan7.eu/edef1c/systemd-zfs-generator";
      rev = "80b3a2daf23a0d9abd2e1b1642d1064a7f875397";
      sha256 = "0qm7cvd91pj4q7v7yjzr2wqqdnzm6iqkjipd63k4676hjcmlkmfy";
    };
    gummibootr = pkgs.fetchgit {
      url = "https://code.nathan7.eu/edef1c/gummibootr";
      rev = "8c2110bfb02d029e163c146dcc05133961ec8a00";
      sha256 = "00xay0bgjy3ffqznnrqvyvprj6ypkk4i9chf2y03vj4q425rxf3s";
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
    loader.gummiboot = {
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
