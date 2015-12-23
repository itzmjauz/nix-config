{ goPackages, fetchgit, ... }:
(goPackages.buildGoPackage rec {
  name = "sshttp";
  goPackagePath = "code.nathan7.eu/nathan7/sshttp";
  GO15VENDOREXPERIMENT = 1;
  src = fetchgit {
    url = "https://${goPackagePath}";
    rev = "1a1fb25a046dd81581b2b8b67e9252e512870e08";
    sha256 = "083am3b833ziiy5xkr1fwwh6zyr4fgzqvxihivpvawha8d2vi6w3";
  };
}).bin
