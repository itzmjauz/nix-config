{ config, pkgs, lib, ... }:
with lib;
rec {
  imports = [
    ../boot/plume-boot.nix
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    #<nixpkgs/nixos/modules/config/fonts/fontconfig-ultimate.nix>
    ../kernel.nix
    (fetchTarball {
         url = "https://github.com/itzmjauz/nixos-declarative-fish-plugin-mgr/archive/refs/tags/0.0.5.tar.gz";
         sha256 = "028liknkgzg8132xpyfj6xjqdv1vhr3k6i32ahmw93dwwkaw0p4g";
      })
  ];

  environment.variables.EDITOR = "kak";
  # enable flakes
  nix = { 
    package = pkgs.nixFlakes; 
    extraOptions = lib.optionalString 
      (config.nix.package == pkgs.nixFlakes) 
      "experimental-features = nix-command flakes"; 
  };

  # neovim overlay for 0.5(nightly)
  nixpkgs.overlays  = [
    (import ./../overlays/neovim.nix)
  ];

  services.xserver = {
    enable = true;
    #    plainX = true;
    #windowManager.awesome.enable = true;
    windowManager.xmonad = {
      enable = true;
      config = builtins.readFile ./../modules/xmonad/plume/xmonad.hs;
      enableContribAndExtras = true;
      extraPackages = haskellPackackages: with pkgs.haskellPackages; [
        pkgs.haskellPackages.xmonad-contrib
        pkgs.haskellPackages.xmonad
        pkgs.haskellPackages.split
      ];
    };
    libinput = {
        enable = true;
        mouse = {
		naturalScrolling = true;
                additionalOptions = ''
        		Option "ScrollPixelDistance" "500"
                '';
        };
    };
    desktopManager.xterm.enable = false;
    xkbOptions = "compose:caps";
    displayManager.lightdm = {
      enable = true;
      greeters.mini = {
        enable = true;
        user = "itzmjauz";
      };
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
  #nixpkgs.config.chromium.enableWideVine = true; # for netflix

  # shell + theme
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      source ${../modules/config.fish}
    '';
    plugins = [
      "oh-my-fish/theme-agnoster"
    ];
  };
  # browser
  programs.chromium = {
    enable = true;
    extensions = [ "eimadpbcbfnmbkopoojfekhnkhdbieeh"]; # dark-theme(toggle for each site)
  };

  users = let
    attrs = {
    };
  in {
    users.root = attrs;
    defaultUserShell = "/run/current-system/sw/bin/fish";
    extraUsers.itzmjauz = attrs // {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    };
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ 
      source-code-pro 
      carlito 
      font-awesome 
      mononoki
      (nerdfonts.override { fonts = ["FiraCode"]; })
    ];
  };

  nix.nixPath = pkgs.lib.mkBefore [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
    "nixpkgs-overlays=/etc/nixos/overlays"
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";
  
  networking.usePredictableInterfaceNames = false; # fuck that noise

  services.resolved = {
    enable = true;
  };

  #save my eyes please
  location.latitude = 52.314487;
  location.longitude = 4.64127;

  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

#  services.xserver.displayManager.sessionCommands = builtins.concatStringsSep "\n" [
  #  "${pkgs.terminator}/bin/terminator -e \"fish -c 'while true; panther; end'\" &"
#    "${pkgs.networkmanagerapplet}/bin/nm-applet &"
    #    "${pkgs.slack}/bin/slack -u &"
#  ];

  services.kmscon = {
    enable = true;
    extraOptions = "--term xterm-256color --palette solarized";
  };
  boot.kernelParams = [
    "vt.default_red=0x07,0xdc,0x85,0xb5,0x26,0xd3,0x2a,0xee,0x00,0xcb,0x58,0x65,0x83,0x6c,0x93,0xfd"
    "vt.default_grn=0x36,0x32,0x99,0x89,0x8b,0x36,0xa1,0xe8,0x2b,0x4b,0x6e,0x7b,0x94,0x71,0xa1,0xf6"
    "vt.default_blu=0x42,0x2f,0x00,0x00,0xd2,0x82,0x98,0xd5,0x36,0x16,0x75,0x83,0x96,0xc4,0xa1,0xe3"
  ];

  services.openssh.enable = true;# set to true for ssh server
  # services.postgresql.enable = true
  # services.avahi.enable = true;
  # graphics
  services.xserver.videoDrivers = [ "nvidia" ];

  # system base packages
  environment.systemPackages = with pkgs; let
    gtk-icons = pkgs.hicolor_icon_theme;
  in [
    # configs
    terminatorsauce awesomesauce # terminator/awesome configs
    # Deployment tools
    qemu #nixops python pkgs broken
    # setup fundamentals
    wget pkgs.boot acpi which xorg.xf86inputsynaptics powertop htop whois file
    # screen settings/setup/utility
    rofi xcompmgr arandr xorg.xbacklight #backlight settings ( utilised through awesome configs as well )
    # window manager
    libnotify xorg.xdpyinfo dzen2 xdotool feh xmobar trayer volumeicon networkmanagerapplet
    # shell/terminals
    fish terminator alacritty
    # browser - music 
    chromium spotify neomutt
    # web development
    nodejs vscode-with-extensions
    # programming / compilation / low-level development
    gdb gcc ghc clojure ctags rustup python3 rustc
    # package management 
    rustup python38Packages.pip
    # development / utility
    ctags git git-hub evince nix-index ranger du-dust
    # offensive/defense pentesting toolsi 
    msf radare2 radare2-cutter nmap python38Packages.pwntools gobuster nikto
    # editor, installed in their respective configs 
    texlab rnix-lsp tree-sitter kak-lsp rust-analyzer # vim_configurable kakoune
    # ssh / utility / steam-run is big, but allows for easy running of benign binaries (without linking issues)
    mosh tmux tree steam-run steam
    # utility
    gtk-icons compton pass gnupg alsaUtils gnome3.eog unzip exa scrot flameshot discord
  ];
}
