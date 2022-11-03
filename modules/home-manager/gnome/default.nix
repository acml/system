{ config, pkgs, ... }: {
  imports = [ ./dconf.nix ];

  # packages = with pkgs; [ gnome.gnome-tweaks ];

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru";
    };

    theme = {
      package = pkgs.yaru-theme;
      name = "Yaru-dark";
    };

    gtk3.extraConfig = {
      gtk-icon-theme-name = "Yaru";
      gtk-theme-name = "Yaru-dark";
      gtk-application-prefer-dark-theme = 1;
    };
  };
  services.gnome-keyring.enable = true;
}
