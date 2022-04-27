{ config, lib, pkgs, ... }: {
  imports = [ ./apps-minimal.nix ];
  homebrew = {
    casks = [
      "android-file-transfer"
      "appcleaner"
      "diffmerge"
      "discord"
      # "maccy"
      "meld"
      # "displaperture"
      # "fork"
      # "gpg-suite"
      # "iina"
      # "keybase"
      # "skim"
      # "syncthing"
      # "zoom"
    ];
    masApps = { };
  };
}
