{ lib, config, pkgs, ... }: with lib;
{
  config = mkIf (elem pkgs.steam config.environment.systemPackages) {
    networking.firewall = {
      # allow Steam in-home streaming ports
      allowedTCPPorts = [ 27031 27036 ];
      allowedUDPPorts = [ 27036 27037 ];
    };
  };
}
