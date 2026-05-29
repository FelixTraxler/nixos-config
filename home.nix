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

      plugins = with pkgs; [
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-dir "$HOME/.tmux/resurrect"
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '1'
          '';
        }
      ];
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
      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 14px;
        }
        window {
          background-color: #0a0a0a;
          border: 2px solid #00cc55;
        }
        #input {
          background-color: #0a0a0a;
          color: #c8c8c8;
          border: none;
          border-bottom: 1px solid #222222;
          padding: 8px 12px;
          margin: 0;
          outline: none;
        }
        #inner-box {
          background-color: #0a0a0a;
        }
        #outer-box {
          padding: 4px;
        }
        #entry {
          padding: 6px 12px;
          color: #c8c8c8;
        }
        #entry:selected {
          background-color: #111111;
          color: #00cc55;
        }
        #text:selected {
          color: #00cc55;
        }
      '';
    };

    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
      settings = {
        background_opacity    = "0.92";
        background            = "#0a0a0a";
        foreground            = "#c8c8c8";
        selection_background  = "#00cc55";
        selection_foreground  = "#0a0a0a";
        cursor_color          = "#00cc55";
        # Black
        color0  = "#1a1a1a";
        color8  = "#333333";
        # Red
        color1  = "#cc3333";
        color9  = "#ff4444";
        # Green
        color2  = "#00cc55";
        color10 = "#00ff66";
        # Yellow
        color3  = "#ccaa00";
        color11 = "#ffcc00";
        # Blue (kept muted so it doesn't pop)
        color4  = "#557799";
        color12 = "#6688aa";
        # Magenta (muted)
        color5  = "#884488";
        color13 = "#aa55aa";
        # Cyan
        color6  = "#009966";
        color14 = "#00bb77";
        # White
        color7  = "#aaaaaa";
        color15 = "#dddddd";

        cursor_shape          = "beam";
        cursor_blink_interval = "0";
        scrollback_lines      = "10000";
        enable_audio_bell     = "no";
        window_padding_width  = "8";
      };
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
    pkgs.glow
    pkgs.gh
  ];
}
