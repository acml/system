{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "dozer"
      "firefox"
      "foobar2000"
      "keepingyouawake"
      "kitty"
      "raycast"
      "rectangle"
      "stats"
    ];
  };
}
