{ config, pkgs, ...}:
{
    environment.systemPackages = with pkgs; [
        (neovim.override {
            vimAlias = true;
            viAlias = true;
        })
    ];

    # write configs
    environment.etc."xdg/nvim/config" = {
        source = ./config;
    };
    #environment.etc."xdg/nvim/sysinit.vim".text = builtins.readFile ./init.vim;
    environment.etc."xdg/nvim/sysinit.vim".text = builtins.readFile ./rewrite.vim;
}
