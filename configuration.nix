{ lib, ... }:
rec {
  imports = ["/etc/nixos/modules/" "/etc/nixos/machines/nightingale.nix"];
# networking.hostName = lib.removeSuffix "\n" (builtins.readFile /etc/hostname);
  networking.hostName = "nightingale";
}
