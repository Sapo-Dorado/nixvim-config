{
  globals.mapleader = " ";
  keymaps = [
    {
      key = "<leader>q";
      action = "<cmd>qall<CR>";
      options = {
        desc = "Quit Neovim";
        silent = true;
      };
    }
    {
      key = "<leader>-";
      action = "<C-W>s";
      options = {
        desc = "Split Window Below";
        silent = true;
      };
    }
    {
      key = "<leader>|";
      action = "<C-W>v";
      options = {
        desc = "Split Window Right";
        silent = true;
      };
    }
    {
      mode = "t";
      key = "<C-n>";
      action = "<c-\\><c-n>";
      options = {
        desc = "Enter Normal Mode";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ud";
      action.__raw = ''
        function()
          if vim.diagnostic.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }) then
            vim.diagnostic.enable(false, { bufnr = vim.api.nvim_get_current_buf() }) -- Disable diagnostics for the current buffer
          else
            vim.diagnostic.enable(true, { bufnr = vim.api.nvim_get_current_buf() }) -- Enable diagnostics for the current buffer
          end
          vim.notify(string.format("Buffer Diagnostics %s", vim.diagnostic.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }), "info"))
        end
      '';
      options = { desc = "Buffer Diagnostics toggle"; };
    }

    {
      mode = "n";
      key = "<leader>uD";
      action.__raw = ''
        function()
          if vim.diagnostic.is_enabled() then
            vim.diagnostic.enable(false) -- Disable diagnostics for the current buffer
          else
            vim.diagnostic.enable(true) -- Enable diagnostics for the current buffer
          end
          vim.notify(string.format("Global Diagnostics %s", vim.diagnostic.is_enabled(), "info"))
        end

      '';
      options = { desc = "Global Diagnostics toggle"; };
    }

  ];
}
