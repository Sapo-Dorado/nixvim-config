{
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = true;
      trouble = true;
    };
  };
  keymaps = [
    {
      mode = [ "n" "v" ];
      key = "<leader>gr";
      action = ":Gitsigns reset_hunk<CR>";
      options = { desc = "Reset Hunk"; };
    }
    {
      mode = "n";
      key = "[h";
      action = {
        __raw =
          # lua
          ''
            function()
              if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
              else
                package.loaded.gitsigns.nav_hunk("prev")
              end
            end

          '';

      };
      options = { desc = "Prev Hunk"; };
    }
    {
      mode = "n";
      key = "]h";
      action = {
        __raw =
          # lua
          ''
            function()
              if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
              else
                package.loaded.gitsigns.nav_hunk("next")
              end
            end

          '';

      };
      options = { desc = "Next Hunk"; };
    }
  ];
}
