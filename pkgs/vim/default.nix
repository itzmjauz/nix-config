{ neovim, man, enableDebugging }:
neovim.overrideDerivation (drv: {
  postInstall = ''
    substituteInPlace $out/share/nvim/runtime/autoload/man.vim --replace /usr/bin/man ${man}/bin/man

    cat > $out/bin/nvimdiff <<EOF
    #!/usr/bin/env sh
    exec $out/bin/nvim -d "\$@"
    EOF
    chmod +x $out/bin/nvimdiff

    ln -s nvim.1 $out/share/man/man1/vim.1
    ln -s nvim $out/bin/vim
    ln -s nvimdiff $out/bin/vimdiff
  '';
})
