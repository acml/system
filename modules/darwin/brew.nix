{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    global = {
      brewfile = true;
      lockfiles = true;
    };

    brews = [ "pngpaste" ];

    taps = [
      "1password/tap"
      "beeftornado/rmtree"
      "cloudflare/cloudflare"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
      "teamookla/speedtest"
    ];
    casks = [
      "appcleaner"
      "discord"
      "dozer"
      "hammerspoon"
      "meld"
      "raycast"
      "stats"
    ];
    masApps = { };
  };
}
