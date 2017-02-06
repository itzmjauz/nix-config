{ config, pkgs, ... }:
rec {
  imports = [
    ../boot
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/config/fonts/fontconfig-ultimate.nix>
    ../kernel.nix
  ];

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; let
    gtk-icons = pkgs.hicolor_icon_theme;
  in [ transgui powertop openbox slack clojure xboxdrv nox xcompmgr acpi xorg.xbacklight python jdk aws nixops evince pythonPackages.pgcli psmisc arandr mpv transmission glxinfo xonotic ghc vim vimsauce nodejs fish chromium neovim terminator terminatorsauce nix-repl silver-searcher which mosh compton git pass gnupg ctags editorconfig-core-c alsaUtils whois xorg.xf86inputsynaptics htop pv taskwarrior file gnome3.eog unzip jq git-hub pkgs.boot libreoffice skype wget spotify steam gtk-icons awesomesauce ];

  services.xserver = {
    enable = true;
    windowManager.awesome.enable = true;
    desktopManager.xterm.enable = false;
    synaptics = {
      enable = true;
      tapButtons = false;
      twoFingerScroll = true;
    };
    xkbOptions = "compose:caps";
    displayManager.slim = {
      enable = true;
      defaultUser = "itzmjauz";
      theme = ../slim-theme;
    };
  };

  networking.networkmanager.enable = true;

  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.chromium.enablePepperFlash = true;

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    source ${../modules/config.fish}
  '';

  users = let
    attrs = {
      openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDxqZL1HZNdc1oYnRzU/JICU7h8r6ueqFQdlk8lLMuDMvTKnbpOHaqcWshgTcfq04SCvylEEQggj9ZINEONlVa+itWtfRhbx90zRiYjerN9RttnXPQEecvwIjQ8ybw+KdsfvorCCXEClixzSimZckyXb0Q18nAR6pnAM+Cya8ZDetL/LlNKN+yolST1ATxWMQrVK5+qbrd6foAS/I2o8SFEsNOw/+8oCbCNkF3kE1hoPWIIO3bFrDW/3CFDZWQHaD058jfzovSz+k5HCFNCVYVwHl7HLNGHKeYgN56GAWU1qBmOJhKYVj7xIKVK3F1y9Ccror9Q7tDiQoRe5b+NzRbX itzmjauz@nightingale"  ];
    };
  in {
    users.root = attrs;
    defaultUserShell = "/run/current-system/sw/bin/fish";
    extraUsers.itzmjauz = attrs // {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ source-code-pro carlito ];
  };

  nix.nixPath = [
   "nixpkgs=/home/itzmjauz/src/github.com/NixOS/nixpkgs"
   "nixos-config=/etc/nixos/configuration.nix"
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";
  
  networking.usePredictableInterfaceNames = false; # fuck that noise

  services.redshift = {
    enable = true;
    latitude = "52.314487";
    longitude = "4.64127";
    temperature.night = 6000;
    brightness.night = "1";
    extraOptions = [ "-r" ];
  };

  services.xserver.displayManager.sessionCommands = builtins.concatStringsSep "\n" [
  #  "${pkgs.terminator}/bin/terminator -e \"fish -c 'while true; panther; end'\" &"
    "${pkgs.networkmanagerapplet}/bin/nm-applet &"
    "${pkgs.slack}/bin/slack -u &"
  ];

  services.kmscon = {
    enable = true;
    extraOptions = "--term xterm-256color --palette solarized";
  };
  boot.kernelParams = [
    "vt.default_red=0x07,0xdc,0x85,0xb5,0x26,0xd3,0x2a,0xee,0x00,0xcb,0x58,0x65,0x83,0x6c,0x93,0xfd"
    "vt.default_grn=0x36,0x32,0x99,0x89,0x8b,0x36,0xa1,0xe8,0x2b,0x4b,0x6e,0x7b,0x94,0x71,0xa1,0xf6"
    "vt.default_blu=0x42,0x2f,0x00,0x00,0xd2,0x82,0x98,0xd5,0x36,0x16,0x75,0x83,0x96,0xc4,0xa1,0xe3"
  ];

  # virtualisation.docker = {
    #  enable = true;
    #  storageDriver = "zfs";
    # socketActivation = false;
  # };

  services.openssh.enable = true;
  # services.postgresql.enable = true;
  # services.avahi.enable = true;
  # graphics
  services.xserver.videoDrivers = [ "intel" ];

  # try to fix chromecast stuff
  networking.firewall.enable = true;
}
