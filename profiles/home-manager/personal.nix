{ config, lib, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
  };
  programs.git = {
    enable = false;
    userEmail = "ozgezer@gmail.com";
    userName = "Ahmet Cemal Özgezer";
  };
}
