{ inputs, config, lib, pkgs, nixpkgs, stable, ... }: {
  imports = [ ./primary.nix ./nixpkgs.nix ./overlays.nix ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  user = {
    description = "Ahmet Cemal Ozgezer";
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.zsh;
  };

  # bootstrap home manager using system config
  hm = import ./home-manager;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs lib; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # environment setup
  environment = {
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${nixpkgs}";
      stable.source = "${stable}";
      trunk.source = "${inputs.trunk}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bash zsh fish ];
  };

  fonts.fonts = with pkgs; [ 
     emacs-all-the-icons-fonts
     noto-fonts-emoji
     (nerdfonts.override {
       fonts = [
         "IBMPlexMono"
         "Iosevka"
         "Overpass"
       ];
     }) 
  ];
}
