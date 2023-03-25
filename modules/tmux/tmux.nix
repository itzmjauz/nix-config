{ config, pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.tmux ];

    
    etc."tmux.conf".text = builtins.readFile ./tmux.conf;
    etc."tmux.conf.local".text = builtins.readFile ./tmux.conf.local;
  };
}
