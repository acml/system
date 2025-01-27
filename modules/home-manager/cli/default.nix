{ config, pkgs, lib, ... }:
let
  functions = builtins.readFile ./functions.sh;
  useSkim = false;
  useFzf = !useSkim;
  fuzz =
    let fd = "${pkgs.fd}/bin/fd";
    in
    rec {
      defaultCommand = "${fd} -H --type f";
      defaultOptions = [ "--height 50%" ];
      fileWidgetCommand = "${defaultCommand}";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --color=always --plain --line-range=:200 {}'"
      ];
      changeDirWidgetCommand = "${fd} --type d";
      changeDirWidgetOptions =
        [ "--preview '${pkgs.tree}/bin/tree -C {} | head -200'" ];
      historyWidgetOptions = [ ];
    };
  aliases = rec {
    # ls = "${pkgs.coreutils}/bin/ls --color=auto -h";
    # la = "${ls} -a";
    # ll = "${ls} -la";
    # lt = "${ls} -lat";
  } // lib.optionalAttrs pkgs.stdenvNoCC.isDarwin rec {
    # darwin specific aliases
    ibrew = "arch -x86_64 brew";
    abrew = "arch -arm64 brew";
  };
in
{
  home.packages = [ pkgs.tree ];
  programs = {
    ssh = {
      enable = true;
      includes = [ "config.d/*" ];
      forwardAgent = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        # stolen from @i077; store .direnv in cache instead of project dir
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n "${config.xdg.cacheHome}"/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
            )}"
        }

        layout_poetry() {
          if [[ ! -f pyproject.toml ]]; then
            log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
            exit 2
          fi

          # create venv if it doesn't exist
          poetry run true

          export VIRTUAL_ENV=$(poetry env info --path)
          export POETRY_ACTIVE=1
          PATH_add "$VIRTUAL_ENV/bin"
        }
      '';
    };
    scmpuff.enable = true;
    skim = {
      enable = useSkim;
    } // fuzz;
    fzf = {
      enable = useFzf;
    } // fuzz;
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        color = "always";
      };
    };
    btop.enable = true;
    htop.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    bash = {
      enable = true;
      shellAliases = aliases;
      profileExtra = ''
        if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
          source ~/.nix-profile/etc/profile.d/nix.sh
        fi
        if [ -n "''${WSLENV}" ] ; then
          export WAYLAND_DISPLAY='wayland-1'
          if command -v setxkbmap >/dev/null; then
            setxkbmap us -variant colemak
          fi
        fi
        export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}
      '';
      initExtra = ''
        ${functions}
      '';
    };
    nix-index.enable = true;
    zsh = let
      mkZshPlugin = { pkg, file ? "${pkg.pname}.plugin.zsh" }: rec {
        name = pkg.pname;
        src = pkg.src;
        inherit file;
      };
    in {
      enable = true;
      autocd = true;
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";
      enableAutosuggestions = true;             # Auto suggest options and highlights syntact, searches in history for options
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      localVariables = {
        LANG = "en_US.UTF-8";
        GPG_TTY = "/dev/ttys000";
        DEFAULT_USER = "${config.home.username}";
        CLICOLOR = 1;
        LS_COLORS = "ExFxBxDxCxegedabagacad";
        TERM = "xterm-256color";
      };
      shellAliases = aliases;
      initExtraBeforeCompInit = ''
        fpath+=~/.zfunc
      '';
      initExtra = ''
        ${functions}
        ${if pkgs.stdenvNoCC.isDarwin then ''
          [[ -d /usr/local/Homebrew ]] && eval "$(/usr/local/Homebrew/bin/brew shellenv)"
        '' else
          ""}
        unset RPS1
        [[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && source ~/.nix-profile/etc/profile.d/nix.sh
        if [ -n "''${WSLENV}" ] ; then
          export WAYLAND_DISPLAY='wayland-1'
          if command -v setxkbmap >/dev/null; then
            setxkbmap us -variant colemak
          fi
        fi
        export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}
      '';
      profileExtra = ''
          ${lib.optionalString pkgs.stdenvNoCC.isLinux "[[ -e /etc/profile ]] && source /etc/profile"}
      '';
      plugins = with pkgs; [
        (mkZshPlugin { pkg = zsh-autopair; })
        # (mkZshPlugin { pkg = zsh-completions; })
        # (mkZshPlugin { pkg = zsh-history-substring-search; })
      ];
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
  };
}
