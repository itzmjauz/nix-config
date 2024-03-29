{ config, pkgs, ... }:
{
  environment.etc.hostname.text = config.networking.hostName;

  nixpkgs.config.packageOverrides = import ../pkgs;
  environment.etc."nix/nixpkgs-config.nix".text = "(import <nixpkgs/nixos> {}).config.nixpkgs.config";
  nix.settings.sandbox = true;

  #nix.binaryCachePublicKeys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" "colossus.nathan7.eu:4iYLGVtL9WTE0OXgPQgQex0BIYopHxFuIYTERQ0dhCc=" ];
  #nix.trustedBinaryCaches = [ "http://hydra.nixos.org/" ];

  #environment.variables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
}
