{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "android-file-transfer"
      "appcleaner"
      "bartender"
      "bitwarden"
      "diffmerge"
      "firefox"
      "karabiner-elements"
      "keepassxc"
      "keepingyouawake"
      "kitty"
      "maccy"
      "meld"
      "raycast"
      "stats"
      "visual-studio-code"
      "vlc"
    ];
    masApps = { };
  };
}
