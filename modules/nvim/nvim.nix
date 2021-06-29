{ config, pkgs, ...}:
{
    environment.systemPackages = with pkgs; [
        (neovim.override {
            vimAlias = true;
            configure = {
                customRC = builtins.readFile ./init.vim;
            };
        })
    ];
}
