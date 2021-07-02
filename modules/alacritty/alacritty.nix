{ config, pkgs, ... }:
{
  environment.etc."xdg/alacritty.yml".text = builtins.concatStringsSep "\n" [
    (builtins.readFile ./alacritty.yml)
    (builtins.readFile ./onedark.yml)
  ];
}
