{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "bartender"
      "firefox"
      "keepingyouawake"
      "kitty"
      "raycast"
      "rectangle"
      "stats"
    ];
  };
}
