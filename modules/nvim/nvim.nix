{ config, pkgs, ...}:
{
    environment.systemPackages = with pkgs; [
        (neovim.override {
            vimAlias = true;
            viAlias = true;
        })
    ];

    # write configs
    environment.etc."xdg/nvim/lua" = {
        source = ./lua;
    };
    #environment.etc."xdg/nvim/sysinit.vim".text = builtins.readFile ./init.vim;
    #environment.etc."xdg/nvim/sysinit.vim".text = builtins.readFile ./rewrite.vim;
    environment.etc."xdg/nvim/sysinit.vim".text = builtins.readFile ./luawrapper.vim;
    environment.etc."xdg/nvim/init.lua".text = builtins.readFile ./init.lua;
}
