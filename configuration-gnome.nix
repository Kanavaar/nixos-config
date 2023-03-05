# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  # Use nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Shells
  environment.shells = with pkgs; [ zsh dash bash ];

  # Enable zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "exa -la --group-directories-first";
      gca = "git add . && git commit";
      gp = "git push";
      gcl = "git clone";
      gcm = "git commit";
      cat = "bat";
      grep = "rg";
      ":q" = "exit";
      "lock" = "betterlockscreen -l blur && exit";
    };
  };

  # Starship
  programs.starship.enable = true;

  # Use systemd-boot, Gpt, Uefi
  # boot.loader.systemd-boot.enable = true;

  # Use grub Efi
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  # boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

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
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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
  services.xserver.videoDrivers = ["nvidia"];


  # Enable DE/WM and lightdm
  # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  # Wayland
  hardware.nvidia.modesetting.enable = true;
  programs.xwayland.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  hardware.opengl.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver = {
	layout = "de";
	xkbVariant = "nodeadkeys";
	xkbOptions = "caps:ctrl";
  };
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing = {
  enable = true;
  drivers = [ pkgs.gutenprint ];
  };

  # services.printing.enable = true;
  # services.printing.drivers = [ "gutenprint" ];

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
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
    home = "/home/tilman";
    extraGroups = [ "wheel" "audio" "video" "networkmanager" "usb" "users" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # Home manager
    home-manager
    
    # DE/WM
    ## Login
    lightdm
    ## XFCE stuff
    xfce.thunar
    xfce.thunar-volman
    ## WM's
    awesome
    # bspwm
    ## Bar
    # polybar
    ## Icons, themes and gtk setter 
    lxappearance
    qogir-theme
    qogir-icon-theme
    arc-theme
    tela-icon-theme
    capitaine-cursors
    ## Applications Laucnher
    rofi
    dmenu
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
    lapce
   
    # GUI Applications
    ## Image stuff
    # gimp
    #feh
    nsxiv
    variety
    feh
    # inkscape
    ## Video Stuff
    mpv
    ## Browser
    qutebrowser
    brave
    ## Office
    # libreoffice
    ## PDF
    zathura
    pandoc
    texlive.combined.scheme-full
    quarto
    rPackages.tinytex
    ## chatting
    discord
    # Mail
    evolution

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
    busybox
    exa
    bat
    ## TUi Programms
    moar
    ## Shells
    zsh
    dash
    
    # Other utils
    xorg.xsetroot
    xorg.xkill
    xsel
    xclip
    networkmanager
    caffeine-ng
    ## Sound
    volumeicon
    pulsemixer
    pamixer
    pavucontrol

    # Music
    playerctl
    spotify
    musescore
    # ncmpcpp
    # mopidy
    # mopidy-mpd

    # Terminal
    alacritty
    wezterm
    
    # Programming languages
    rustup
    gcc
    gnumake
    gnupatch

    # Gnome
    gnomeExtensions.pop-shell
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-panel
    gnomeExtensions.caffeine
    gnome.cheese
    gnome.gnome-characters
    gnome.gnome-chess
    gnuchess
    gnome.gnome-tweaks
  ];

  environment.localBinInPath = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
        "application/pdf" = "zathura.dekstop";
        "img/png" = [
            "nsxiv.desktop"
          ];
      };
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  services.emacs = {
      install = true;
      package = pkgs.emacs-gtk;
      enable = true;
    };

  # Font
  fonts.fonts = with pkgs; [
    nerdfonts
    corefonts
    winePackages.fonts
    vistafonts
    emacs-all-the-icons-fonts
    etBook
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.askPassword = "";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  
  # Auto upgrading
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
}

