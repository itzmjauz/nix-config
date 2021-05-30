pkgs: let inherit (pkgs) callPackage; in {
  awesomesauce = callPackage ./awesome/config.nix {};
  terminator = callPackage ./terminator { inherit (pkgs) terminator; };
  terminatorsauce = callPackage ./terminator/config.nix {};
}

