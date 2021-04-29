{ config, pkgs, ... }:
let
  patchf = attrs: {
    name = attrs.name or (baseNameOf attrs.url);
    patch = pkgs.fetchurl attrs;
  };
in
{
  boot.kernelModules = ["msr" "kvm-amd"];
  boot.kernelParams = [ ];
  # boot.kernelPatches = [ {
    #  name = "thp-enable";
    #  patch = null;
    #    extraConfig = ''
    #      TRANSPARENT_HUGEPAGE_MADVISE? n
    #  TRANSPARENT_HUGEPAGE? y
    #  TRANSPARENT_HUGEPAGE_ALWAYS? y
    #  '';
    #} ];
}
