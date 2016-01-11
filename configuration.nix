{ config, pkgs, ... }:
rec {
  imports = [
    ./boot
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/config/fonts/fontconfig-ultimate.nix>
  ];

  boot.kernelPackages = pkgs.linuxPackages_4_3;

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; let
    sshttp = pkgs.callPackage ./pkgs/sshttp {};
  in [ nixops evince pythonPackages.pgcli psmisc arandr thunderbird mpv transmission glxinfo xonotic ghc vim nodejs fish chromium neovim terminator nix-repl silver-searcher which mosh compton git pass gnupg sshttp ctags editorconfig-core-c alsaUtils whois xorg.xf86inputsynaptics htop pv taskwarrior file gnome3.eog unzip jq git-hub pkgs.boot libreoffice atom skype wget spotify steam ];

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
      theme = ./slim-theme;
    };
  };

  networking.hostName = "meerkat";
  networking.networkmanager.enable = true;

  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.chromium.enablePepperFlash = true;

  users = let
    attrs = {
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG9SzR0M6zpb8Jy0/zRLwMeuJEjrAYTtOWzrt7HGgHBth/uuMcydYUAnYAj8L9wMyGfNnCdwbx+PAm86cFHqrpVVlUkGk3JxmL+SrNwJ8DcYbvgGIKuIesc2eFfkoYo/LVBTxUpkwuINwyL+M1h7IK9b6SQ2j7DLelF2svQtS4OhNpl/sDf9UDBatejel4lFWxCEh0Bre8Y0WOukb866W5c9q/dJr5Bs6OA/CKES1YhQUw/g3PX3+XcOQ6fpfZhEIAZJvkoBUfh1N9TUOdQ4rwvFx3inRYpIzbiA+QlGnyE1WHcE+FY0FlKU/IocayInkYvWwwGJusx0L7O1IdqzIl nathan@koala" ];
    };
  in {
    users.root = attrs;
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

  services.logind.extraConfig = "HandleLidSwitch=ignore\nHandlePowerKey=suspend";

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";

  services.physlock = {
    enable = true;
    user = "itzmjauz";
  };
  security.setuidPrograms = [ "physlock" ];

  nix.useChroot = true;
  nix.chrootDirs = [ "/usr/bin/env=${pkgs.coreutils}/bin/env" ];

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
    "${pkgs.terminator}/bin/terminator -e \"fish -c 'while true; panther; end'\" &"
    "${pkgs.terminator}/bin/terminator -e \"fish -c 'while true; badaluma; end'\" &"
    "${pkgs.networkmanagerapplet}/bin/nm-applet &"
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

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
    socketActivation = false;
  };

  services.openssh.enable = false;
  services.postgresql.enable = true;
# services.avahi.enable = true;
  # graphics
  hardware.bumblebee.enable = true;
  hardware.bumblebee.driver = "nvidia";
  services.xserver.videoDrivers = [ "intel" ];
  nixpkgs.config.steam.primus = true;

  # try to fix chromecast stuff
  networking.firewall.enable = false;
}
