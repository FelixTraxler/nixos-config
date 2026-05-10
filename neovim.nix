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

      luaConfigRC.winborder = ''
        vim.o.winborder = "rounded"
      '';

      keymaps = [
        {
          key = "<leader>e";
          mode = "n";
          action = ":Oil<CR>";
        }
        {
          key = "<leader>r";
          mode = "n";
          action = ":edit!<CR>";
          desc = "Reload file from disk";
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
        scrolloff = 10;
        sidescrolloff = 10;

        colorcolumn = "100";
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
      ui.fastaction.enable = true;

      autocomplete.nvim-cmp.enable = true;

      autopairs.nvim-autopairs.enable = true;

      binds.whichKey.enable = true;

      utility.surround.enable = true;

      statusline.lualine.enable = true;

      comments.comment-nvim.enable = true;

      telescope = {
        enable = true;
      };

      utility.oil-nvim = {
        enable = true;
        gitStatus.enable = true;
        setupOpts.view_options.show_hidden = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
      };
    };
  };
}
