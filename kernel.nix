{ config, pkgs, ... }:
let
  patchf = attrs: {
    name = attrs.name or (baseNameOf attrs.url);
    patch = pkgs.fetchurl attrs;
  };
  linux = pkgs.linux_4_4.override {
    extraConfig = ''
      IOSCHED_BFQ y
    '';
    kernelPatches = builtins.map patchf [
      {
        url = http://algo.ing.unimo.it/people/paolo/disk_sched/patches/4.4.0-v7r11/0001-block-cgroups-kconfig-build-bits-for-BFQ-v7r11-4.4.0.patch;
        sha256 = "1kmlfz63610zc4lxhanjsn4hhw43cdsbk3pyaij723vbd7619kyi";
      }
      {
        url = http://algo.ing.unimo.it/people/paolo/disk_sched/patches/4.4.0-v7r11/0002-block-introduce-the-BFQ-v7r11-I-O-sched-for-4.4.0.patch;
        sha256 = "1i5jqkxglp3ah76i4vyi13pnmjkr6qlqy69qbaj2132vijqkyz5i";
      }
      {
        url = http://algo.ing.unimo.it/people/paolo/disk_sched/patches/4.4.0-v7r11/0003-block-bfq-add-Early-Queue-Merge-EQM-to-BFQ-v7r11-for.patch;
        sha256 = "09bv31s8d2aphi3d9py4sz1gcvyb5645a8s7zj614a56hv11p8k9";
      }
    ];
  };
  linuxPackages = pkgs.linuxPackagesFor linux;
in
{
  boot.kernelModules = ["msr"];
  boot.kernelPackages = linuxPackages;
  boot.kernelParams = [ "elevator=bfq" ];
}
