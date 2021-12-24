{ config, lib, pkgs, ... }: {
  homebrew = {
    cleanup = "zap";
    brews = [
      "pngpaste"
    ];
    casks = [
      "android-file-transfer"
      "appcleaner"
      "bartender"
      "bitwarden"
      "diffmerge"
      "firefox"
      # "karabiner-elements"
      "keepingyouawake"
      "kitty"
      "maccy"
      "meld"
      "raycast"
      "stats"
      # "visual-studio-code"
      # "vlc"
    ];
    masApps = { };
  };
}
