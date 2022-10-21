{ config, lib, pkgs, ... }: {
  user.name = "${config.home.username}";
  hm = { imports = [ ./home-manager/work.nix ]; };

  security.pki.certificateFiles =
    [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" "/etc/certs.d/apl.pem" ];
}
