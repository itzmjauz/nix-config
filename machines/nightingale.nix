{ config, pkgs, lib, ... }:
with lib;
rec {
  imports = [
    ../boot
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    #<nixpkgs/nixos/modules/config/fonts/fontconfig-ultimate.nix>
    ../kernel.nix
    (fetchTarball {
         url = "https://github.com/itzmjauz/nixos-declarative-fish-plugin-mgr/archive/refs/tags/0.0.5.tar.gz";
         sha256 = "028liknkgzg8132xpyfj6xjqdv1vhr3k6i32ahmw93dwwkaw0p4g";
      })
  ];

  environment.variables.EDITOR = "vim";
  nix = { 
    package = pkgs.nixFlakes; 
    extraOptions = lib.optionalString 
      (config.nix.package == pkgs.nixFlakes) 
      "experimental-features = nix-command flakes"; 
  };

  services.xserver = {
    enable = true;
    #    plainX = true;
    windowManager.awesome.enable = true;
    desktopManager.xterm.enable = false;
    synaptics = {
      enable = true;
      tapButtons = false;
      twoFingerScroll = true;
    };
    xkbOptions = "compose:caps";
    displayManager.lightdm = {
      enable = true;
      greeters.mini = {
        enable = true;
        user = "itzmjauz";
      };
#      theme = ../slim-theme;
    };
  };

  systemd.targets.zfs = {
    wantedBy = ["local-fs.target" "multi-user.target"];
    wants = ["zfs-mount.service"];
    before = ["local-fs.target" "multi-user.target" "sysinit.target"];
  };
  systemd.services.zfs-mount.requires = ["zfs-import.target"];
  networking.firewall.enable = true;

  networking.networkmanager.enable = true;

  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.chromium.enableWideVine = true;


  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      source ${../modules/config.fish}
    '';
    plugins = [
      "oh-my-fish/theme-agnoster"
    ];
  };

  users = let
    attrs = {
    };
  in {
    users.root = attrs;
    defaultUserShell = "/run/current-system/sw/bin/fish";
    extraUsers.itzmjauz = attrs // {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" "libvirtd" ];
    };
    #extraUsers.guest = {
      #  isNormalUser = true;
      #  extraGroups = [ "networkmanager" ];
      #  password = "hunter2";
      #};
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ source-code-pro carlito ];
  };

  nix.nixPath = pkgs.lib.mkBefore [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";
  
  networking.usePredictableInterfaceNames = false; # fuck that noise

  services.resolved = {
    enable = true;
  };

  services.xserver.displayManager.sessionCommands = builtins.concatStringsSep "\n" [
  #  "${pkgs.terminator}/bin/terminator -e \"fish -c 'while true; panther; end'\" &"
    "${pkgs.networkmanagerapplet}/bin/nm-applet &"
    #    "${pkgs.slack}/bin/slack -u &"
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

  services.openssh.enable = true;
  virtualisation.docker.enable = false;

  # services.postgresql.enable = true
  # services.avahi.enable = true;
  # graphics
  services.xserver.videoDrivers = [ "intel" ];

  # system base packages
  environment.systemPackages = with pkgs; let
    gtk-icons = pkgs.hicolor_icon_theme;
  in [
    # configs
    terminatorsauce awesomesauce # terminator/awesome configs
    # Deployment tools
    nixops
    # setup fundamentals
    wget pkgs.boot acpi which xorg.xf86inputsynaptics powertop htop whois file
    # screen settings/setup/utility
    xcompmgr arandr xorg.xbacklight #backlight settings ( utilised through awesome configs as well )
    # shell/terminals
    fish terminator
    # browser
    chromium
    # web development
    nodejs
    # programming / compilation / low-level development
    gdb gcc ghc clojure ctags rustup python3
    # package management 
    rustup python38Packages.pip
    # development / utility
    ctags git git-hub
    # offensive/defense pentesting toolsi [TODO Nikto is in unstable]
    msf radare2 radare2-cutter nmap python38Packages.pwntools gobuster
    # editor, installed in their respective configs 
    kak-lsp rust-analyzer # vim_configurable kakoune
    # ssh / utility
    mosh
    # utility
    gtk-icons compton pass gnupg alsaUtils gnome3.eog unzip
  ];
}
