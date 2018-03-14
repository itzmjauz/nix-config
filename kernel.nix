{ config, pkgs, ... }:
let
  patchf = attrs: {
    name = attrs.name or (baseNameOf attrs.url);
    patch = pkgs.fetchurl attrs;
  };
in
{
  boot.kernelModules = ["msr" "kvm-amd"];
  boot.kernelParams = [ "elevator=bfq" ];
}
