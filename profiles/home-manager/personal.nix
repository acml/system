{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "ozgezer@gmail.com";
    userName = "Ahmet Cemal Özgezer";
  };
}
