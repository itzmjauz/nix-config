let
  nixos = import <nixpkgs/nixos> {
    system = "x86_64-linux";
    configuration = import ./configuration.nix;
  };
in { system = nixos.config.system.build.toplevel; }
