{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "android-file-transfer"
      "appcleaner"
      "bartender"
      # "bitwarden"
      "diffmerge"
      "discord"
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
