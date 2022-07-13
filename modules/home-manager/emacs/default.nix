{ config, inputs, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  EDITOR = "emacsclient -tc";
  ALTERNATE_EDITOR = "emacs";
in
lib.mkMerge [
  {

    programs = {
      jq.enable = true;      # cli to extract data out of json input
    };

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # fonts
      emacs-all-the-icons-fonts
      nerdfonts

      (lib.mkIf isDarwin coreutils-prefixed)

      man-pages
      posix_man_pages

      exercism

      ## Doom dependencies
      (ripgrep.override { withPCRE2 = true; })
      ripgrep-all

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      unzip
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies

      # :checkers spell
      (aspellWithDicts
        (dicts: with dicts; [ en en-computers en-science tr ]))

      # :checkers grammar
      languagetool

      # :tools editorconfig
      editorconfig-core-c # per-project style config

      # :tools lookup & :lang org +roam
      sqlite
      (lib.mkIf isLinux maim) # org-download-clipboard
      gnuplot                 # org-plot/gnuplot
      graphviz                # org-roam-graph
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-full

      # :lang cc
      clang-tools
      glslang

      # CMake LSP
      cmake
      cmake-language-server

      # Nix
      nixfmt

      # Markdown exporting
      mdl pandoc

      # Python LSP setup
      # nodePackages.pyright
      # pipenv
      # (python3.withPackages (ps: with ps; [
      #   black isort pyflakes pytest
      # ]))

      # JavaScript
      # nodePackages.typescript-language-server

      # HTML/CSS/JSON language servers
      nodePackages.prettier
      nodePackages.vscode-langservers-extracted

      # Bash
      nodePackages.bash-language-server shellcheck

      # :lang lua
      # (lib.mkIf isLinux sumneko-lua-language-server)
      sumneko-lua-language-server

      # Rust
      # cargo cargo-audit cargo-edit clippy rust-analyzer rustfmt

      # :lang go
      go_1_18
      gocode
      gomodifytags
      delve # vscode
      gopkgs # vscode
      go-outline # vscode
      golint # vscode
      golangci-lint
      gopls
      gotests
      gore

      # :app everywhere
      xclip xdotool

      trash-cli
    ];

    programs.emacs = {
      enable = true;
      package = lib.mkMerge [
        (lib.mkIf isLinux pkgs.emacsPgtkNativeComp)
        (lib.mkIf isDarwin pkgs.emacsPgtkNativeComp)
      ];
      extraPackages = epkgs: (with epkgs.melpaPackages; [
        pdf-tools
        vterm
      ]) ++ (with epkgs.elpaPackages; [
        # auctex
      ]) ++ (with epkgs.nongnuPackages; [
        # org-contrib
      ])++ [
        # pkgs.mu
      ];
    };

    home.sessionVariables = {
      inherit DOOMLOCALDIR DOOMDIR EDITOR ALTERNATE_EDITOR;
    };
    systemd.user.sessionVariables = lib.mkIf isLinux {
      inherit DOOMLOCALDIR DOOMDIR EDITOR ALTERNATE_EDITOR;
    };

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      source = ./doom.d;
      force = true;
    };

    xdg.configFile."emacs" = {
      source = pkgs.applyPatches {
        name = "doom-emacs-source";
        src = inputs.doom-emacs-source;
        # patches = [ ./doom.d/disable_install_hooks.patch ];
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
        if [ ! -d "$DOOMLOCALDIR" ]; then
          ''${HOME}/.config/emacs/bin/doom --force install
        else
          ''${HOME}/.config/emacs/bin/doom --force sync -u
        fi
      ''}";
      force = true;
    };
  }
  # user systemd service for Linux
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
      # The client is already provided by the Doom Emacs final package
      client.enable = false;
    };

    systemd.user.services.emacs = {
      Unit.PartOf = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session-pre.target" ];
      Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
    };
  })
]
