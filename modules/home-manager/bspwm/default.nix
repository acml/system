{ config, pkgs, ... }: {

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };

    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };

    cursorTheme = {
      package = pkgs.paper-gtk-theme;
      name = "Paper";
      size = 16;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 16;
    x11.enable = true;
  };
  xsession.preferStatusNotifierItems = true;

  home.packages = with pkgs; [
    dconf     # gtk.enable = true depends on this
    feh       # image viewer
    xclip
    xdotool
    xorg.xwininfo
    libqalculate  # calculator cli w/ currency conversion
    (makeDesktopItem {
      name = "scratch-calc";
      desktopName = "Calculator";
      icon = "calc";
      exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
      categories = [ "Development" ];
    })
    qgnomeplatform        # QPlatformTheme for a better Qt application inclusion in GNOME
    libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
    libnotify
    (polybar.override {
      pulseSupport = true;
      nlSupport = true;
    })
    (writeScriptBin "rofi" ''
        #!${stdenv.shell}
        exec ${pkgs.rofi}/bin/rofi -terminal kitty -m -1 "$@"
      '')

    # Fake rofi dmenu entries
    # (makeDesktopItem {
    #   name = "rofi-browsermenu";
    #   desktopName = "Open Bookmark in Browser";
    #   icon = "bookmark-new-symbolic";
    #   exec = "${config.dotfiles.binDir}/rofi/browsermenu";
    # })
    # (makeDesktopItem {
    #   name = "rofi-browsermenu-history";
    #   desktopName = "Open Browser History";
    #   icon = "accessories-clock";
    #   exec = "${config.dotfiles.binDir}/rofi/browsermenu history";
    # })
    # (makeDesktopItem {
    #   name = "rofi-filemenu";
    #   desktopName = "Open Directory in Terminal";
    #   icon = "folder";
    #   exec = "${config.dotfiles.binDir}/rofi/filemenu";
    # })
    # (makeDesktopItem {
    #   name = "rofi-filemenu-scratch";
    #   desktopName = "Open Directory in Scratch Terminal";
    #   icon = "folder";
    #   exec = "${config.dotfiles.binDir}/rofi/filemenu -x";
    # })

    # (makeDesktopItem {
    #   name = "lock-display";
    #   desktopName = "Lock screen";
    #   icon = "system-lock-screen";
    #   exec = "${config.dotfiles.binDir}/zzz";
    # })
  ];

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      copycat
      prefix-highlight
      yank
      resurrect
    ];
  };

  services = {
    dunst.enable = true;

    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      fade = true;
      fadeDelta = 1;
      fadeSteps = [ 0.01 0.012 ];
      shadow = true;
      shadowOffsets = [ (-10) (-10) ];
      shadowOpacity = 0.22;
      # activeOpacity = "1.00";
      # inactiveOpacity = "0.92";
      opacityRules = [
        # "100:class_g = 'Firefox'"
        # "100:class_g = 'Vivaldi-stable'"
        "100:class_g = 'VirtualBox Machine'"
        # Art/image programs where we need fidelity
        "100:class_g = 'Gimp'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'aseprite'"
        "100:class_g = 'krita'"
        "100:class_g = 'feh'"
        "100:class_g = 'mpv'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'Peek'"
        "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
      ];
      shadowExclude = [
        # Put shadows on notifications, the scratch popup and rofi only
        "! name~='(rofi|scratch|Dunst)$'"
      ];
      settings = {
        shadow-radius = 12;
        # blur-background = true;
        # blur-background-frame = true;
        # blur-background-fixed = true;
        blur-kern = "7x7box";
        blur-strength = 320;
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "class_g = 'Rofi'"
          "_GTK_FRAME_EXTENTS@:c"
        ];

        # Unredirect all windows if a full-screen opaque window is detected, to
        # maximize performance for full-screen windows. Known to cause
        # flickering when redirecting/unredirecting windows.
        unredir-if-possible = true;

        # GLX backend: Avoid using stencil buffer, useful if you don't have a
        # stencil buffer. Might cause incorrect opacity when rendering
        # transparent content (but never practically happened) and may not work
        # with blur-background. My tests show a 15% performance boost.
        # Recommended.
        glx-no-stencil = true;

        # Use X Sync fence to sync clients' draw calls, to make sure all draw
        # calls are finished before picom starts drawing. Needed on
        # nvidia-drivers with GLX backend for some users.
        xrender-sync-fence = true;
      };
    };
    redshift.enable = true;
    redshift.latitude = 40.92;
    redshift.longitude = 29.28;
    sxhkd.enable = true;
  };

  # link recursively so other modules can link files in their folders
  xdg = {
    enable = true;
    configFile = {
      "xtheme/90-theme".source = ./config/Xresources;
      "sxhkd".source = ./config/sxhkd;
      "bspwm" = {
        source = ./config/bspwm;
        recursive = true;
      };
      "bspwm/rc.d/00-theme".source = ./config/bspwmrc;
      "bspwm/rc.d/95-polybar".source = ./config/polybar/run.sh;
      "rofi/theme" = { source = ./config/rofi; recursive = true; };
      "polybar" = { source = ./config/polybar; recursive = true; };
      "dunst/dunstrc".source = ./config/dunstrc;
      "Dracula-purple-solid-kvantum" = {
        recursive = true;
        source = "${pkgs.dracula-theme}/share/themes/Dracula/kde/kvantum/Dracula-purple-solid";
        target = "Kvantum/Dracula-purple-solid";
      };
      "kvantum.kvconfig" = {
        text = "theme=Dracula-purple-solid";
        target = "Kvantum/kvantum.kvconfig";
      };
      "tmux" = { source = ./config/tmux; recursive = true; };
    };
    dataFile = {
      "wallpaper".source = ./config/wallpaper.png;
    };
  };
}
