rec {
#  imports = [ /etc/nixos/modules (/etc/nixos/machines + "/${networking.hostName}.nix") ];
  imports = ["/etc/nixos/modules/" "/etc/nixos/machines/nightingale.nix"];
  networking.hostName = builtins.readFile /etc/hostname;
}
