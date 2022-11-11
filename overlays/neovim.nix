self: super: {
  libvterm-neovim = super.libvterm-neovim.overrideAttrs (oldAttrs : {
    version = "0.3";
    src = (builtins.fetchTarball https://www.leonerd.org.uk/code/libvterm/libvterm-0.3.tar.gz);
    nativeBuildInputs = super.libvterm.nativeBuildInputs ++ [self.perl self.libtool];
  });

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "master";
    src = builtins.fetchGit {
      url = https://github.com/neovim/neovim.git;
      ref = "release-0.8";
      rev = "81781810e6e1c3538c2cd3e220b30b81bbdd0362";
    };
    nativeBuildInputs = super.neovim-unwrapped.nativeBuildInputs ++ [ super.tree-sitter self.cmake self.binutils-unwrapped self.libvterm-neovim];
  });

  
}
