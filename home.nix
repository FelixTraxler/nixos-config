{pkgs, lib, ...}: let
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
        lg = "lazygit";
        random = "openssl rand -base64 12";
        nv = "nvim .";
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
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

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
      ];
    };

    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
      settings = {
        background_opacity = "0.92";
        background = "#0a0a0a";
        foreground = "#c8c8c8";
        selection_background = "#00cc55";
        selection_foreground = "#0a0a0a";
        cursor_color = "#00cc55";
        # Black
        color0 = "#1a1a1a";
        color8 = "#333333";
        # Red
        color1 = "#cc3333";
        color9 = "#ff4444";
        # Green
        color2 = "#00cc55";
        color10 = "#00ff66";
        # Yellow
        color3 = "#ccaa00";
        color11 = "#ffcc00";
        # Blue (kept muted so it doesn't pop)
        color4 = "#557799";
        color12 = "#6688aa";
        # Magenta (muted)
        color5 = "#884488";
        color13 = "#aa55aa";
        # Cyan
        color6 = "#009966";
        color14 = "#00bb77";
        # White
        color7 = "#aaaaaa";
        color15 = "#dddddd";

        scrollback_lines = "10000";
        enable_audio_bell = "no";
        window_padding_width = "8";
      };
    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        yzhang.markdown-all-in-one
        ms-toolsai.jupyter
      ];
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xdg.desktopEntries.firefox-video = {
    name = "Firefox";
    exec = "firefox %f";
    mimeType = ["video/mp4" "video/webm" "video/ogg"];
    noDisplay = true;
    type = "Application";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = "firefox-video.desktop";
    };
  };

  programs.i3status.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    # Use the Sway package and session wrapper provided by NixOS.
    package = null;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.wofi}/bin/wofi --show drun";

      # Keep the display scale usable on the laptop's high-resolution panel.
      output."*" = {
        scale = "1.57";
        bg = "#202020 solid_color";
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          repeat_delay = "200";
          repeat_rate = "35";
        };
        "type:touchpad".natural_scroll = "enabled";
      };

      bars = [{
        position = "bottom";
        statusCommand = "${pkgs.i3status}/bin/i3status";
      }];

      startup = [{command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";}];

      # Extend the standard Sway shortcuts with screenshots and screen locking.
      keybindings = lib.mkOptionDefault {
        "Print" = "exec ${snip}/bin/snip";
        "Mod4+Control+l" = "exec ${pkgs.swaylock}/bin/swaylock -c 202020";
      };
    };

    extraConfig = ''
      bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+
      bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
      bindsym --locked XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindsym --locked XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindsym --locked XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym --locked XF86AudioPlay exec playerctl play-pause
      bindsym --locked XF86AudioNext exec playerctl next
      bindsym --locked XF86AudioPrev exec playerctl previous
    '';
  };
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
    pkgs.openssl
    pkgs.unzip
    pkgs.elan
  ];
}
