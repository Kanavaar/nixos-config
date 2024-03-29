# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Allow Unfree
  nixpkgs = {
    config.allowUnfree = true;
  };

  # Use nix-command
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      options = "--max-freed 1G --delete-older-than 7d";
    };
  };


  # Shells
  environment.shells = with pkgs; [ zsh dash bash ];

  # Enable zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "exa -lha --group-directories-first";
      gca = "git add . && git commit";
      gp = "git push";
      gcl = "git clone";
      gcm = "git commit";
      cat = "bat";
      grep = "rg";
      df = "df -h";
      ":q" = "exit";
    };
    autosuggestions = {
      enable = true;
    };
    enableCompletion = true;
    enableBashCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
  };

  # Starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      directory = {
        style = "blue";
        truncation_length = 100;
        truncate_to_repo = false;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };
      character = {
        success_symbol = "[󰘧](green)";
        error_symbol = "[󰘧](red)";
        vimcmd_symbol = "[❮](purple)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = " [$duration]($style) ";
        style = "yellow";
      };
    };
  };

  # Use systemd-boot, Gpt, Uefi
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    blacklistedKernelModules = [ "nouveau" ];
    supportedFilesystems = [ "ntfs" ];
  };

  # boot.loader.systemd-boot.enable = true;

  # Use grub Efi
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.devices = [ "nodev" ];
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.useOSProber = true;

  # Use the GRUB 2 boot loader. Master Boot Record Bios
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  networking.hostName = "binary"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    #  keyMap = "de";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Nvidia Driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # Xdg desktop integration
  xdg = {
    portal = {
      enable = true;
    };
  };

  # Enable DE/WM and lightdm
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
    };
  };
  # services.xserver.displayManager.sddm.theme = "${(pkgs.fetchFromGitHub {
  #     owner = "MarianArlt";
  #     repo = "sddm-sugar-dark";
  #     rev = "v1.2";
  #     sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
  #   })}";
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.windowManager.bspwm = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
    xkbOptions = "caps:escape";
  };
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr pkgs.gutenprint ];
  };

  # enable virtualisation
  virtualisation.libvirtd.enable = true;
  boot.extraModprobeConfig = "options kvm_intel";
  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  # Enable sound.
  security.rtkit.enable = true;
  sound.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tilman = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Tilman Andre Mix";
    home = "/home/tilman";
    extraGroups = [ "libvirtd" "wheel" "audio" "video" "networkmanager" "usb" "users" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Printing
    system-config-printer

    # Mail
    evolution

    # virtualisation
    virt-manager

    # DE/WM
    ## XFCE stuff
    xfce.thunar
    xfce.thunar-volman
    ## WM's
    ## Bar
    polybar
    # waybar # wayland
    ## Icons, themes and gtk setter 
    lxappearance
    orchis-theme
    graphite-gtk-theme
    tela-circle-icon-theme
    capitaine-cursors
    # Themes to test, don't commit
    materia-theme
    paper-icon-theme
    vimix-icon-theme
    vimix-gtk-themes
    papirus-icon-theme
    ## Applications Laucnher
    rofi
    dmenu
    # fuzzel # wayland
    ## lockscreen
    betterlockscreen
    ## Hotkey setter
    sxhkd
    ## Notification
    dunst
    ## Screenshot
    scrot
    ## Compositor
    picom

    # Text Editor
    ## Terminal
    # vim
    neovim
    ## GUI
    emacs-gtk

    # GUI Applications
    ## Image stuff
    # gimp
    feh # wallpaper
    # swww # wayland wallpaper
    imv
    # inkscape
    ## Video Stuff
    mpv
    ## Browser
    qutebrowser
    brave
    librewolf
    ## Office
    # libreoffice
    ## PDF
    zathura
    pandoc
    texlive.combined.scheme-full
    ## chatting
    discord

    # Terminal stuff
    ## CMD I need
    wget
    curl
    git
    zip
    unzip
    gnutar
    file
    fzf
    tmux
    btop
    groff
    ripgrep
    fd
    busybox
    exa # ls
    bat # cat
    lfs # df replacement
    du-dust # du
    zoxide # cd
    hyperfine # time
    stow
    aria
    nmap
    ## TUi Programms
    moar
    lf
    ## Shells
    zsh
    dash

    # Other utils
    xorg.xsetroot
    xsel
    xclip
    wl-clipboard
    networkmanager
    caffeine-ng
    # wlogout # wayland
    # seatd # needed for hyprland
    ## Rss
    ratt
    photon-rss
    ## Sound
    volumeicon
    pulsemixer
    pamixer
    pavucontrol

    # Music
    playerctl
    spotify
    # ncmpcpp
    # mopidy
    # mopidy-mpd

    # Terminal
    # alacritty
    wezterm
    # foot # wayland

    # Programming languages
    rustup # Rust
    gcc
    gnumake
    gnupatch

    # LSP Server
    rust-analyzer
    gopls
    zls
    nil

    # Emacs till home-manager
    emacsPackages.vterm

    # Nix-direnv
    direnv
    nix-direnv

    # Wayland
    # hyprland-protocols
    # hyprland-share-picker
    # xdg-desktop-portal-hyprland
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  services.lorri = {
    enable = true;
    package = pkgs.lorri;
  };

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  # Font
  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts
      corefonts
      winePackages.fonts
      vistafonts
      emacs-all-the-icons-fonts
      overpass
      lato
    ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.askPassword = "";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Auto upgrading
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=20s";
  };
}

