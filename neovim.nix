{
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = false;
      vimAlias = true;
      lsp = {
        enable = true;
        formatOnSave = true;
      };

      options = {
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        # Languages that will be supported in default and maximal configurations.
        nix.enable = true;
        markdown.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
      };
    };
  };
}
