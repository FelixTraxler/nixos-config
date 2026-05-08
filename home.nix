{pkgs, ...}: let
  snip = pkgs.writeShellScriptBin "snip" ''
    grim -l 0 -g "$(slurp)" - | wl-copy
  '';

  zoomWayland = pkgs.writeShellScriptBin "zoom" ''
    exec ${pkgs.zoom-us}/bin/zoom \
      --enable-features=UseOzonePlatform,WaylandWindowDecorations \
      --ozone-platform=wayland \
      "$@"
  '';
in {
  home = {
    username = "felix";
    homeDirectory = "/home/felix";

    stateVersion = "25.11";
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

    tmux = {
      enable = true;
      sensibleOnTop = true;
      shortcut = "a";
      keyMode = "vi";
      mouse = true;

      extraConfig = ''
        bind -n M-h select-pane -L
        bind -n M-l select-pane -R
        bind -n M-k select-pane -U
        bind -n M-j select-pane -D
      '';
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
  home.file.".local/share/applications/Zoom.desktop".text = ''
    [Desktop Entry]
    Name=Zoom Workplace
    Comment=Zoom Video Conference
    Exec=${zoomWayland}/bin/zoom %U
    Icon=Zoom
    Terminal=false
    Type=Application
    Categories=Network;Application;
    StartupWMClass=zoom
    MimeType=x-scheme-handler/zoommtg;x-scheme-handler/zoomus;x-scheme-handler/tel;x-scheme-handler/callto;x-scheme-handler/zoomphonecall;x-scheme-handler/zoomphonesms;x-scheme-handler/zoomcontactcentercall;application/x-zoom;
    X-KDE-Protocols=zoommtg;zoomus;tel;callto;zoomphonecall;zoomphonesms;zoomcontactcentercall;
  '';

  home.packages = [
    snip
    zoomWayland
    pkgs.htop
    pkgs.fortune
    pkgs.tree
  ];
}
