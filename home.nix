{pkgs, ...}: {
  home = {
    username = "felix";
    homeDirectory = "/home/felix";

    stateVersion = "25.11";
  };

  programs = {
    home-manager.enable = true;

    firefox = {
      enable = true;

      policies = {
        ExtensionSettings = {
          "*" = {
            installation_mode = "allowed";
          };

          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
        };
      };
    };
  };

  home.packages = [
    pkgs.htop
    pkgs.fortune
  ];
}
