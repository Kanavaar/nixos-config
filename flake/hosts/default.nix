{ config, pkgs, lib, ... }: {
  # Nixpkgs config
  nixpkgs = {
    config.allowUnfree = true;
  };

  # Nix package manager config
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      options = "--max-freed 5G --delete-older-than 5d";
    };
  };

  # Programm config
  programs = {
    # ZShell
    zsh = {
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
    # Starship Prompt
    starship = {
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
    # ssh
    ssh = {
      askPassword = "";
    };
  };

  # Packages
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
    # emacs-gtk
    emacsUnstable

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
    sioyek
    typst
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
    du-dust # du replacement
    zoxide # cd
    hyperfine
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
    # rustup # Rust
    gcc
    gnumake
    gnupatch
    (fenix.stable.withComponents [
      "cargo"
      "rust-std"
      "rustc"
      "rustfmt"
    ])

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

  services = {
    # Xorg
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager = {
        lightdm = {
          enable = true;
          greeters.gtk = {
            enable = true;
          };
        };
        sddm = {
          enable = false;
          theme = "${(pkgs.fetchFromGitHub {
            owner = "MarianArlt";
            repo = "sddm-sugar-dark";
            rev = "1.2";
            sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
          })}";
        };
      };
      windowManager = {
        awesome.enable = true;
        bspwm.enable = true;
      };
      # Keyboard
      layout = "de";
      xkbVariant = "nodeadkeys";
      xkbOptions = "caps:escape";
      # LibInput: touchpad support
      libinput.enable = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ epson-escpr gutenprint ];
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    gnome = {
      gnome-keyring.enable = true;
    };
    gvfs.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
    };
  };

  sound.enable = false;

  virtualisation.libvirtd.enable = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    supportedFilesystems = [ "ntfs" ];
    blacklistedKernelModules = [ "nouveau" ];
    extraModprobeConfig = "options kvm_intel";
    kernelModules = [ "kvm-intel" "kvm-amd" ];
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  security = {
    rtkit.enable = true;
  };

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

  system = {
    stateVersion = "23.05";
    autoUpgrade = {
      enable = false;
      allowReboot = false;
    };
  };

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=20s";
  };

  environment = {
    localBinInPath = true;
    homeBinInPath = true;
    sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
  };
}
