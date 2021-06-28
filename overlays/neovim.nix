self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "master";
    src = builtins.fetchGit {
      url = https://github.com/neovim/neovim.git;
      rev = "5aaa1a1c0473d9e9ac824201f92ec65e190beeb7";
    };
    nativeBuildInputs = super.neovim-unwrapped.nativeBuildInputs ++ [ super.tree-sitter self.cmake self.binutils-unwrapped ];
  });
}
