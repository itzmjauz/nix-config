{ config, pkgs, ... }:
let
  guessIndent = pkgs.vimUtils.buildVimPlugin {
    name = "guessindent";
    src = pkgs.fetchFromGitHub {
      owner = "ogier";
      repo = "guessindent";
      rev = "c0925ad024b6ba53d943413eed502f8e6ed13a83";
      sha256 = "170pfzzm0n2ppyxfk16zvizi828cb3avdss0fqpi555q1cpy83n5";
    };
  buildInputs = [ pkgs.zip pkgs.vim ];
  };

  myVimPlugins = with pkgs.vimPlugins; [
    vim-nix
    vim-colors-solarized
    guessIndent
  ];
in
{
  environment.systemPackages = with pkgs; [
    (vim_configurable.customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = myVimPlugins;
	opt =[];
      };
      vimrcConfig.customRC = builtins.readFile "/etc/nixos/pkgs/vim/init.vim";
    })
    (neovim.override {
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = myVimPlugins;
	  opt = [];
	};
        customRC = builtins.readFile "/etc/nixos/pkgs/vim/init.vim";
      };
    })
  ];
}
