{ self, inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
in
{
  # nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  imports = [
    ./emacs
    ./nvim
    ./cli
    # ./kitty
    ./dotfiles
    ./git.nix
    ./1password
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager = {
    enable = true;
    path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
  };

  home =
    let NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
    in
    {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "22.05";
      sessionVariables = {
        GPG_TTY = "/dev/ttys000";
        EDITOR = "nvim";
        VISUAL = "nvim";
        CLICOLOR = 1;
        LSCOLORS = "ExFxBxDxCxegedabagacad";
        KAGGLE_CONFIG_DIR = "${config.xdg.configHome}/kaggle";
        NODE_PATH = "${NODE_GLOBAL}/lib";
        # HOMEBREW_NO_AUTO_UPDATE = 1;
      };
      sessionPath = [
        "${NODE_GLOBAL}/bin"
        "${config.home.homeDirectory}/.rd/bin"
      ];

    # define package definitions for current user environment
    packages = with pkgs; [
        # python with default packages
        (pkgs.python3.withPackages
          (ps: with ps; [
            numpy
            scipy
            networkx
          ]))
      coreutils-full
      curl
      fd
      gnugrep
      gnupg
      gnused
      htop
      mc
      nix
      nixfmt
      nixpkgs-fmt
      openssh
      parallel
      ranger
      #(ruby.withPackages (ps: with ps; [ rufo solargraph ]))
      self.packages.${system}.sysdo
    ];
  };

}
