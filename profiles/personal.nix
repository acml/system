{ config, lib, pkgs, ... }: {
  user.name = "ahmet";
  hm = { imports = [ ./home-manager/personal.nix ]; };
}
