rec {
  imports = [ ./modules (./machines + "/${networking.hostName}.nix") ];
  networking.hostName = builtins.readFile /etc/hostname;
}
