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
    fonts.fontconfig.enable = true;

    # Extra packages that are already part of my config
    # won't be duplicated
    # Of course, all of these packages can be overriden
    # by direnv (envrc)
    home.packages = with pkgs; [
      # fonts
      emacs-all-the-icons-fonts
      jetbrains-mono
      (pkgs.nerdfonts.override {
        fonts = [
         "IBMPlexMono"
         "Iosevka"
         "Overpass"
         "SourceCodePro"
        ];
      })
      noto-fonts-emoji

      (lib.mkIf isDarwin coreutils-prefixed)

      man-pages
      posix_man_pages

      ## Doom dependencies
      (ripgrep.override { withPCRE2 = true; })
      ripgrep-all

      ## Optional dependencies
      jq # cli to extract data out of json input
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

      # :lang cc
      ccls
      #clang-tools # for clangd
      (lib.mkIf isLinux glslang)

      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-full

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

      # :lang lua
      (lib.mkIf isLinux sumneko-lua-language-server)

      # Bash
      nodePackages.bash-language-server shellcheck

      # Rust
      # cargo cargo-audit cargo-edit clippy rust-analyzer rustfmt

      # Erlang and Elixir
      # erlang-ls
      # beamPackages.elixir beamPackages.elixir_ls

      # :lang go
      # go
      # gocode
      # gomodifytags
      # delve # vscode
      # gopkgs # vscode
      # go-outline # vscode
      # golint # vscode
      # golangci-lint
      # gopls
      # gotests
      # gore
    ];

    programs.emacs = {
      enable = true;
      package = lib.mkMerge [
        (lib.mkIf isLinux pkgs.emacsPgtkGcc)
        (lib.mkIf isDarwin pkgs.emacsPgtkGcc)
      ];
      extraPackages = (epkgs:
        (with epkgs; [
          # exwm
          vterm
          pdf-tools
        ]) ++

        # MELPA packages:
        (with epkgs.melpaPackages; [ ]));
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
        patches = [ ./doom.d/disable_install_hooks.patch ];
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
        if [ ! -d "$DOOMLOCALDIR" ]; then
          ''${HOME}/.config/emacs/bin/doom -y install
        else
          ''${HOME}/.config/emacs/bin/doom -y sync -u
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
