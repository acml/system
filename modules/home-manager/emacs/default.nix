{ config, inputs, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  DOOMDIR = "${config.xdg.configHome}/doom";
  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  EDITOR = "emacsclient -tc";
  ALTERNATE_EDITOR = "emacs";
in
lib.mkMerge [
  {

    home.sessionVariables = {
      inherit DOOMDIR DOOMLOCALDIR EDITOR ALTERNATE_EDITOR;
    };
    systemd.user.sessionVariables = lib.mkIf isLinux {
      inherit DOOMDIR DOOMLOCALDIR EDITOR ALTERNATE_EDITOR;
    };

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      source = ./doom.d;
      force = true;
    };

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
      nodePackages.bash-language-server shellcheck shfmt

      # :lang lua
      # (lib.mkIf isLinux sumneko-lua-language-server)
      sumneko-lua-language-server

      # Rust
      # cargo cargo-audit cargo-edit clippy rust-analyzer rustfmt

      # :lang go
      go_1_18
      delve        # vscode
      go-outline   # vscode
      go-tools     # vscode (staticcheck)
      golint       # vscode
      gomodifytags # vscode
      gopkgs       # vscode
      gopls        # vscode
      gotests      # vscode
      impl         # vscode
      gocode
      golangci-lint
      gore
      gotools

      # :app everywhere
      xclip xdotool

      trash-cli
    ];

    programs.emacs = {
      enable = true;
      package = lib.mkMerge [
        (lib.mkIf isLinux pkgs.emacsNativeComp)
        (lib.mkIf isDarwin pkgs.emacsNativeComp)
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
  }

  # user systemd service for Linux
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
      # The client is already provided by the Doom Emacs final package
      client.enable = false;
    };
  })
]
