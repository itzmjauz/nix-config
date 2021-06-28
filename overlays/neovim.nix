self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "master";
    src = builtins.fetchGit {
      url = https://github.com/neovim/neovim.git;
      rev = "8665a96b92553b26c8c9c215900964b8a898595f";
    };
    nativeBuildInputs = super.neovim-unwrapped.nativeBuildInputs ++ [ super.tree-sitter self.cmake self.binutils-unwrapped ];
  });
}
