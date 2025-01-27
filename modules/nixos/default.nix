{ config, pkgs, ... }: {
  # bundles essential nixos modules
  imports = [
    # ./keybase.nix
    ../common.nix
  ];

  services.syncthing = {
    enable = true;
    user = config.user.name;
    group = "users";
    openDefaultPorts = true;
    dataDir = config.user.home;
  };

  environment.systemPackages = with pkgs; [ vscode firefox ];
  environment.extraInit = ''
    # Try really hard to get QT to respect my GTK theme.
    export GTK_DATA_PREFIX="${config.system.path}"
    export QT_QPA_PLATFORMTHEME="gnome"
    export QT_STYLE_OVERRIDE="kvantum"
  '';

  fonts = {
    fontconfig.defaultFonts = {
      sansSerif = [ "Sans" ];
      monospace = [ "Monospace" ];
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      ubuntu_font_family
      dejavu_fonts
      fira-code
      fira-code-symbols
      open-sans
      jetbrains-mono
      siji
      font-awesome
    ];
  };

  # hm = { pkgs, ... }: { imports = [ ../home-manager/gnome ]; };
  hm = { pkgs, ... }: { imports = [ ../home-manager/bspwm ]; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users = {
      "${config.user.name}" = {
        isNormalUser = true;
        extraGroups =
          [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
        hashedPassword =
          "$6$.6NbHKr23r$uD0zVajkT5IWBDeexyn6ZkYmzCCkgpInOrsSGtUsygs6nqTP7Kny2U5zzQSEBnrniYsZoBj35p4PMjaCpzj7l0";
      };
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "${config.user.name}" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  networking.hostName = "darkstar"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp0s31f6.useDHCP = true;
  # networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "colemak/colemak";

  # Set your time zone.
  # time.timeZone = "EST";
  services.geoclue2.enable = true;
  services.localtimed.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "colemak";
    xkbOptions = "ctrl:nocaps";

    # Enable touchpad support.
    libinput.enable = true;

    # Enable the KDE Desktop Environment.
    # services.xserver.displayManager.sddm.enable = true;
    # services.xserver.desktopManager.plasma5.enable = true;

    # gnome
    # displayManager = {
    #   gdm = {
    #     enable = true;
    #     wayland = true;
    #   };
    # };
    # desktopManager.gnome.enable = true;

    # bspwm
    displayManager = {
      sessionCommands = ''
        xsetroot -cursor_name left_ptr
        ${pkgs.feh}/bin/feh --bg-scale --no-xinerama --no-fehbg $XDG_DATA_HOME/wallpaper
        # GTK2_RC_FILES must be available to the display manager.
        export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
      '';
      defaultSession = "none+bspwm";
      lightdm.enable = true;
      lightdm.greeters.mini.enable = true;
      lightdm.greeters.mini.user = config.user.name;
      # Login screen theme
      lightdm.greeters.mini.extraConfig = ''
        text-color = "#bd93f9"
        password-background-color = "#1E2029"
        window-color = "#1a1c25"
        border-color = "#1a1c25"
      '';
      # lightdm.background = cfg.loginWallpaper;
    };
    windowManager.bspwm.enable = true;
  };

  # Clean up leftovers, as much as we can
  system.userActivationScripts.cleanupHome = ''
    pushd "${config.user.home}"
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
