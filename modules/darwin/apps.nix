{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "alt-tab"
      "dozer"
      "firefox"
      "foobar2000"
      "kitty"
      "raycast"
      "stats"
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
