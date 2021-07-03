Nixos system configurations
==========================

Configurations for my systems running nixos

The current configuration is largely built around nightingale.
Portability will increase whenever I get around to running a second nixos machine.

System setup
--------------------------
All systems use a zfs - luks encrypted setup, and should thus be set up accordingly. 
It is loosely based on the setup described in https://nixos.org/manual/nixos/stable/
But with an encrypted root partition, with a ZFS filesystem.
Instructions are on https://nixos.wiki/wiki/NixOS_on_ZFS for the general setup.

Configurations
--------------------------
Nixos allows for my terminal, vim, fish and awesomewm setups to be configured through nix, these can be found in modules/ and pkgs/.

TODO
--------------------------
- [X] Reorganize vim config
- [X] Reorganize wm setup (xmonad mainly) into its own submodule, instead of under modules/ directly
- [ ] Put chromium setup into its own file (even though its only 1 line)
- [X] Host specific configs
- [X] Move from Vim to Neovim when the config allows
- [ ] Setup automatic mail sync 
- [ ] Hopefully switch themes live in alacritty (similar to what terminator can do) 
- [X] Write config files of vim to the standard location instead of manually loading it from /etc/nixos/, 
- [X] Same for alacritty ^ 
- [ ] Same for kakoune ^ 

- [ ] Write better system setup details


Note: not so sure about switching separate config files to .nix variants, since right now I can download one of the files and use it directly on any other system.
