{
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = false;
      vimAlias = true;

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
        providers.wl-copy.package = null;
      };

      keymaps = [
        {
          key = "<leader>e";
          mode = "n";
          action = ":Oil<CR>";
        }
      ];

      lsp = {
        enable = true;
        formatOnSave = true;
      };

      options = {
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        foldlevel = 99; # start with all folds open
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        # Languages that will be supported in default and maximal configurations.
        nix.enable = true;
        markdown.enable = true;
        typescript.enable = true;
        html.enable = true;
        bash.enable = true;
        clang.enable = true;
        css.enable = true;
        java.enable = true;
        json.enable = true;
        python.enable = true;
        typst.enable = true;
        zig.enable = true;
      };

      ui.nvim-ufo.enable = true;

      telescope = {
        enable = true;
      };

      utility.oil-nvim.enable = true;

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
      };
    };
  };
}
