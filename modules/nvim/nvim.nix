{ config, pkgs, ...}:
{
    environment.systemPackages = with pkgs; [
        (neovim.override {
            configure = {
                customRC = builtins.readFile ./init.vim;
            };
        })
    ];
}
