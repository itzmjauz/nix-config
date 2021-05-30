{ config, pkgs, ... }:
let
  guessindent = pkgs.vimUtils.buildVimPlugin {
    name = "guessindent";
    src = pkgs.fetchFromGitHub {
      owner = "ogier";
      repo = "guessindent";
      rev = "c0925ad024b6ba53d943413eed502f8e6ed13a83";
      sha256 = "170pfzzm0n2ppyxfk16zvizi828cb3avdss0fqpi555q1cpy83n5";
    };
    buildInputs = [ pkgs.zip pkgs.vim ];
  };

  css3-syntax = pkgs.vimUtils.buildVimPlugin {
    name = "gcss3-syntax";
    src = pkgs.fetchFromGitHub {
      owner = "hail2u";
      repo = "vim-css3-syntax";
      rev = "012c1ba6a075e2e83267ff5ecb80800e28044190";
      sha256 = "1wswi34xx4nplsi3zqk8p2y605ly6bivih3hswy4j8c1cpf4ajvy";
    };
    buildInputs = [ pkgs.zip pkgs.vim ];
  };

  gnupg = pkgs.vimUtils.buildVimPlugin {
    name = "gnupg";
    src = pkgs.fetchFromGitHub {
      owner = "jamessan";
      repo = "vim-gnupg";
      rev = "8394f2e1b5d9e49c209480eddc6128fe56f21c4a";
      sha256 = "1p9ljrxhg3h63mgqb33vkyn58xns9h16fllhi12abccczi6lfjwc";
    };
    buildInputs = [ pkgs.vim pkgs.which ];
  };
  
  html = pkgs.vimUtils.buildVimPlugin {
    name = "html";
    src = pkgs.fetchFromGitHub {
      owner = "othree";
      repo = "html5\.vim";
      rev = "10dca03366fca80a2b9ec7aed49d2864bcadb8ef";
      sha256 = "0l9yqqm2jm5jwq311pmk4p6mxi39i4pwfd59vanav7nm4idnwbb9";
    };
    buildInputs = [ pkgs.vim pkgs.which pkgs.git pkgs.wget ];
  };

  vim-node = pkgs.vimUtils.buildVimPlugin {
    name = "vim-node";
    src = pkgs.fetchFromGitHub {
      owner = "mmalecki";
      repo = "vim-node\.js";
      rev = "0b5146fa9bd69cba9ce8690c164271a726e3b7b8";
      sha256 = "0ynkii4njya6jdnah1sd41a6ppq7awcp212rpg96ilr5jqbah1yn";
    };
    buildInputs = [ pkgs.vim ];
  };

  paredit = pkgs.vimUtils.buildVimPlugin {
    name = "paredit";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "paredit\.vim";
      rev = "791c3a0cc3155f424fba9409a9520eec241c189c";
      sha256 = "15lg33bgv7afjikn1qanriaxmqg4bp3pm7qqhch6105r1sji9gz9";
    };
    buildInputs = [ pkgs.vim ];
  };

  vim-systemd = pkgs.vimUtils.buildVimPlugin {
    name = "vim-systemd";
    src = pkgs.fetchFromGitHub {
      owner = "Matt-Deacalion";
      repo = "vim-systemd-syntax";
      rev = "a080364581fc7cb7986bd96bfe8d190e2f5ccb4c";
      sha256 = "0d0k7a5qaa03dard11mji4yvrn9r9hqwvq8dplc8fhb9llzz2ygw";
    };
    buildInputs = [ pkgs.vim ];
  };

  myVimPlugins = with pkgs.vimPlugins; [
    airline
    vim-buffergator
    vim-clojure-highlight
    vim-closetag
    css3-syntax
    vim-css-color
    ctrlp
    easymotion
#    vim-easytags TODO deps: exuberant Ctags 5.5
    editorconfig-vim
    vim-fireplace
    vim-fish
    vim-fugitive
    vim-gist
    vim-glsl
    gnupg
    vim-go
    wmgraphviz-vim
    guessindent
#    html  TODO attempts to create dir in buildphase in illegal location
    vim-javascript
    vim-markdown
    vim-misc
    nerdtree
    vim-nix
    vim-node
    paredit
    rainbow_parentheses
    vim-pasta
    repeat
    supertab
    syntastic
    rust-vim
    vim-systemd
    vim-terraform
    vim-toml
    undotree
    vim-unimpaired
    vim-graphql
    webapi-vim
    vim-colors-solarized
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
      vimrcConfig.customRC = builtins.readFile ./init.vim;
    })
  ];
}
