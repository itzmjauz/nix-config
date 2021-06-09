{ config, pkgs, ... }:
{
  environment.etc."xdg/alacritty.yml".text = builtins.readFile ./alacritty.yml;
}
