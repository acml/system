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
    ];
  };
}
