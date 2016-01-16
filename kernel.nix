{ config, pkgs, ... }:
{
  boot.kernelPackages = let
    patchf = attrs: {
      name = if attrs ? name
        then attrs.name
        else baseNameOf attrs.url;
      patch = pkgs.fetchurl attrs;
    };
    linux = pkgs.linux_4_3.override {
      extraConfig = ''
        IOSCHED_BFQ y
        CGROUP_BFQIO y
      '';
      kernelPatches = builtins.map patchf [
        {
          url = http://algo.ing.unimo.it/people/paolo/disk_sched/patches/4.3.0-v7r8/0001-block-cgroups-kconfig-build-bits-for-BFQ-v7r8-4.3.patch;
          sha256 = "14549awmvsqwzb7912k83dmlznx5lak8gcivqjd79clrd4h65szb";
        }
        {
          url = http://algo.ing.unimo.it/people/paolo/disk_sched/patches/4.3.0-v7r8/0002-block-introduce-the-BFQ-v7r8-I-O-sched-for-4.3.patch;
          sha256 = "1sw65hxjimg9w04f7ccrxhl1c8b1ddd21ni9af77cyrkp11cpdwi";
        }
        {
          url = http://algo.ing.unimo.it/people/paolo/disk_sched/patches/4.3.0-v7r8/0003-block-bfq-add-Early-Queue-Merge-EQM-to-BFQ-v7r8-for-4.3.0.patch;
          sha256 = "178spkcwaz79rz8fb7h209grbgr2ca4lbgfmns4d43b7aiqhqhvp";
        }
      ];
    };
    linuxPackages = pkgs.linuxPackagesFor linux linuxPackages;
  in linuxPackages;
  boot.kernelParams = [ "elevator=bfq" ];
}
