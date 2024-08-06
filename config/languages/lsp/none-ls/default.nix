{ lib, ... }@inputs: {
  plugins.none-ls = {
    enable = true;
    settings = {
      default_timeout = 5000;
      on_attach =
        # lua
        ''
          function(client, bufnr)
            if client.supports_method "textDocument/formatting" then
              vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  if (format_enabled()) then
                    vim.lsp.buf.format { bufnr = bufnr }
                  end
                end,
              })
            end
          end
        '';
    };
    sources = {
      diagnostics = {
        golangci_lint.enable = true;
        statix.enable = true;
      };
      formatting = {
        gofmt.enable = true;
        goimports.enable = true;
        nixfmt.enable = true;
        markdownlint.enable = true;
        shellharden.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
        clang_format.enable = true;
        black.enable = true;
        isort.enable = true;
        mdformat.enable = true;
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
        mix = {
          enable = true;
          settings =
            # lua
            ''
              {
                extra_args = { "format" },
              }
            '';
        };
      };
    };
  };

  keymaps = [

    {
      mode = "n";
      key = "<leader>uf";
      action = {
        __raw =
          # lua
          ''
            function()
              toggle_format()
            end
          '';
      };
      options.desc = "Toggle Auto Format (Global)";
    }
    {
      mode = "n";
      key = "<leader>uF";
      action = {
        __raw =
          # lua
          ''
            function()
              toggle_format(true)
            end
          '';
      };
      options.desc = "Toggle Auto Format (Buffer)";
    }
  ];

  extraConfigLua = lib.readFile ./extra-lua-config.lua;
}
