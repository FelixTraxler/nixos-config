{pkgs, ...}: let
  snip = pkgs.writeShellScriptBin "snip" ''
    grim -l 0 -g "$(slurp)" - | wl-copy
  '';
in {
  home = {
    username = "felix";
    homeDirectory = "/home/felix";

    stateVersion = "25.11";

    sessionPath = [
      "$HOME/Android/Sdk/platform-tools"
      "$HOME/Android/Sdk/emulator"
      "$HOME/Android/Sdk/cmdline-tools/latest/bin"
    ];
  };

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake .";
        btr = "upower -b | grep percentage";
      };
    };

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
          "vimium" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          };
        };
      };
    };

    wofi = {
      enable = true;
    };
  };

  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;

  home.packages = [
    snip
    pkgs.htop
    pkgs.fortune
    pkgs.tree
  ];
}
