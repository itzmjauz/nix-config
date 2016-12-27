{ lib, fetchgit, buildEnv, substituteAll, pkgs }:
with lib;
let
  readPlugins = path: let
    readPlugin = key: _: {
      name = removeSuffix ".json" key;
      value = importJSON (path + "/${key}");
    };
  in mapAttrs' readPlugin (builtins.readDir path);
  fetchPlugin = { url, rev, sha256, ... }: fetchgit { inherit url rev sha256; };
  fetchPlugins = mapAttrs (_: fetchPlugin);
  buildConfig = plugins: buildEnv {
    name = "vim-bundle";
    paths = [ init ] ++ (builtins.attrValues plugins);
    ignoreCollisions = true; # TODO: fix this
    extraPrefix = "/etc/xdg/nvim";
  };
  init = substituteAll {
    src = ./init.vim;
    name = "init.vim";
    dir = ".";

    inherit (pkgs.ocamlPackages_4_03) merlin;
    goBinPath = buildEnv {
      name = "vim-go-binpath";
      paths = with pkgs; [ gocode godef gotools golint /* errcheck */ gotags ];
    };
  };
in buildConfig (fetchPlugins (readPlugins ./plugins))
