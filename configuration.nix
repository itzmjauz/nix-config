{ lib, ... }:
rec {
  imports = [ ./modules (./machines + "/${networking.hostName}.nix") ];
  # take first line of etc/hostname
  networking.hostName = lib.head (lib.splitString "\n" (builtins.readFile "/etc/hostname"));
}
