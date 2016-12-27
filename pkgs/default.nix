pkgs: let inherit (pkgs) callPackage; in {
  awesomesauce = callPackage ./awesome/config.nix {};
  vim = callPackage ./vim {};
  vimsauce = callPackage ./vim/config.nix {};
}
