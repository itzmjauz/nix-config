Nixos system configurations
==========================

Configurations for my systems running nixos

System setup
--------------------------
All systems use a zfs - luks encrypted setup, and should thus be set up accordingly. 

Configurations
--------------------------
Nixos allows for my terminal, vim, fish and awesomewm setups to be configured through nix, these can be found in modules/ and pkgs/.

TODO
--------------------------
Prerably automatically recognize the system hostname / or some other identifying parameter to automatically identify which system config to run.

Want to run neovim over vim, but neovim.override behaves differently than vim_configurable.customize, although the docs do not seem to reflect this.
