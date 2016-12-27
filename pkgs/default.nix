pkgs: let inherit (pkgs) callPackage; in {
  vim = callPackage ./vim {};
  vimsauce = callPackage ./vim/config.nix {};
}
