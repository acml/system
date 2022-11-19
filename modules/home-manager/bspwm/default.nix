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
    name = "Paper";
    package = pkgs.paper-icon-theme;
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
        exec ${pkgs.rofi}/bin/rofi -run-shell-command "wezterm start -- {cmd}" -m -1 "$@"
      '')

    # Fake rofi dmenu entries
    cached-nix-shell
    (makeDesktopItem {
      name = "rofi-browsermenu";
      desktopName = "Open Bookmark in Browser";
      icon = "bookmark-new-symbolic";
      exec = "browsermenu";
    })
    (makeDesktopItem {
      name = "rofi-browsermenu-history";
      desktopName = "Open Browser History";
      icon = "accessories-clock";
      exec = "browsermenu history";
    })
    (makeDesktopItem {
      name = "rofi-filemenu";
      desktopName = "Open Directory in Terminal";
      icon = "folder";
      exec = "filemenu";
    })
    (makeDesktopItem {
      name = "rofi-filemenu-scratch";
      desktopName = "Open Directory in Scratch Terminal";
      icon = "folder";
      exec = "filemenu -x";
    })

    (makeDesktopItem {
      name = "lock-display";
      desktopName = "Lock screen";
      icon = "system-lock-screen";
      exec = "zzz";
    })

    (writeScriptBin "autoclicker" (builtins.readFile ./bin/autoclicker))
    (writeScriptBin "focus" (builtins.readFile ./bin/bspwm/focus))
    (writeScriptBin "presel" (builtins.readFile ./bin/bspwm/presel))
    (writeScriptBin "subtract-presel" (builtins.readFile ./bin/bspwm/subtract-presel))
    (writeScriptBin "swap" (builtins.readFile ./bin/bspwm/swap))
    (writeScriptBin "gitinfo" (builtins.readFile ./bin/gitinfo))
    (writeScriptBin "hey" (builtins.readFile ./bin/hey))
    (writeScriptBin "mov2gif" (builtins.readFile ./bin/mov2gif))
    (writeScriptBin "myip" (builtins.readFile ./bin/myip))
    (writeScriptBin "optimimg" (builtins.readFile ./bin/optimimg))
    (writeScriptBin "optimpdf" (builtins.readFile ./bin/optimpdf))
    (writeScriptBin "appmenu" (builtins.readFile ./bin/rofi/appmenu))
    (writeScriptBin "browsermenu" (builtins.readFile ./bin/rofi/browsermenu))
    (writeScriptBin "bwmenu" (builtins.readFile ./bin/rofi/bwmenu))
    (writeScriptBin "filemenu" (builtins.readFile ./bin/rofi/filemenu))
    (writeScriptBin "networkmenu" (builtins.readFile ./bin/rofi/networkmenu))
    (writeScriptBin "passmenu" (builtins.readFile ./bin/rofi/passmenu))
    (writeScriptBin "powermenu" (builtins.readFile ./bin/rofi/powermenu))
    (writeScriptBin "spotifymenu" (builtins.readFile ./bin/rofi/spotifymenu))
    (writeScriptBin "windowmenu" (builtins.readFile ./bin/rofi/windowmenu))
    (writeScriptBin "scratch" (builtins.readFile ./bin/scratch))
    (writeScriptBin "scrcap" (builtins.readFile ./bin/scrcap))
    (writeScriptBin "scrrec" (builtins.readFile ./bin/scrrec))
    (writeScriptBin "since" (builtins.readFile ./bin/since))
    (writeScriptBin "spell" (builtins.readFile ./bin/spell))
    (writeScriptBin "timein" (builtins.readFile ./bin/timein))
    (writeScriptBin "zzz" (builtins.readFile ./bin/zzz))
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
    configFile = let
      colors = {
        black         = "#000000"; # 0
        red           = "#FF0000"; # 1
        green         = "#00FF00"; # 2
        yellow        = "#FFFF00"; # 3
        blue          = "#0000FF"; # 4
        magenta       = "#FF00FF"; # 5
        cyan          = "#00FFFF"; # 6
        silver        = "#BBBBBB"; # 7
        grey          = "#888888"; # 8
        brightred     = "#FF8800"; # 9
        brightgreen   = "#00FF80"; # 10
        brightyellow  = "#FF8800"; # 11
        brightblue    = "#0088FF"; # 12
        brightmagenta = "#FF88FF"; # 13
        brightcyan    = "#88FFFF"; # 14
        white         = "#FFFFFF"; # 15

        # Color classes
        types = {
          bg        = colors.black;
          fg        = colors.white;
          panelbg   = colors.types.bg;
          panelfg   = colors.types.fg;
          border    = colors.types.bg;
          error     = colors.red;
          warning   = colors.yellow;
          highlight = colors.white;
        };
      };
    in  {
      "xtheme.init" = {
        text = ''cat "$XDG_CONFIG_HOME"/xtheme/* | ${pkgs.xorg.xrdb}/bin/xrdb -load'';
        executable = true;
      };
      "xtheme/00-init".text = with colors; ''
        #define bg   ${types.bg}
        #define fg   ${types.fg}
        #define blk  ${black}
        #define red  ${red}
        #define grn  ${green}
        #define ylw  ${yellow}
        #define blu  ${blue}
        #define mag  ${magenta}
        #define cyn  ${cyan}
        #define wht  ${white}
        #define bblk ${grey}
        #define bred ${brightred}
        #define bgrn ${brightgreen}
        #define bylw ${brightyellow}
        #define bblu ${brightblue}
        #define bmag ${brightmagenta}
        #define bcyn ${brightcyan}
        #define bwht ${silver}
       '';
      "xtheme/05-colors".text = ''
          *.foreground: fg
          *.background: bg
          *.color0:  blk
          *.color1:  red
          *.color2:  grn
          *.color3:  ylw
          *.color4:  blu
          *.color5:  mag
          *.color6:  cyn
          *.color7:  wht
          *.color8:  bblk
          *.color9:  bred
          *.color10: bgrn
          *.color11: bylw
          *.color12: bblu
          *.color13: bmag
          *.color14: bcyn
          *.color15: bwht
        '';
      "xtheme/05-fonts".text = ''
         *.font: xft:Monospace:pixelsize=12
         Emacs.font: Monospace:pixelsize=12
       '';
      "xtheme/90-theme".source = ./config/Xresources;
      "sxhkd".source = ./config/sxhkd;
      "bspwm" = {
        source = ./config/bspwm;
        recursive = true;
      };
      # GTK
      "gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-theme-name=Dracula
          gtk-icon-theme-name=Paper
          gtk-cursor-theme-name=Paper
          gtk-fallback-icon-theme=gnome
          gtk-application-prefer-dark-theme=true
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintfull
          gtk-xft-rgba=none
        '';
      # GTK2 global theme (widget and icon theme)
      "gtk-2.0/gtkrc".text = ''
          gtk-theme-name="Dracula"
          gtk-icon-theme-name="Paper"
          gtk-font-name="Sans 10"
        '';
      # QT4/5 global theme
      "Trolltech.conf".text = ''
          [Qt]
          style=Dracula
        '';
      "bspwm/rc.d/00-theme".source = ./config/bspwmrc;
      "bspwm/rc.d/05-init" = {
        text = "$XDG_CONFIG_HOME/xtheme.init";
        executable = true;
      };
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
