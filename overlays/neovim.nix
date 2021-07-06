self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "master";
    src = builtins.fetchGit {
      url = https://github.com/neovim/neovim.git;
      rev = "df33f30e8882b2bf692253d63f73fb602a13f888";
    };
    nativeBuildInputs = super.neovim-unwrapped.nativeBuildInputs ++ [ super.tree-sitter self.cmake self.binutils-unwrapped ];
  });
}
