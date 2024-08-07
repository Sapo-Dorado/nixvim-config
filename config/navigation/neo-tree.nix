{
  plugins.neo-tree = {
    enable = true;
    closeIfLastWindow = true;
    sources = [ "filesystem" "git_status" ];
  };
  autoCmd = [
    {
      event = [ "BufRead" ];
      desc = "Open neo-tree on enter for directories";
      once = true;

      callback = {
        __raw =
          # lua
          ''
            function()
                local stats = vim.uv.fs_stat(vim.fn.argv(0))
                if stats and stats.type == "directory" then
                  vim.cmd "Neotree"
                  vim.cmd "wincmd l"
                end
            end
          '';
      };
    }
    {
      event = [ "TermClose" ];
      desc = "Update neo-tree gitstatus when closing terminal";

      callback = {
        __raw =
          # lua
          ''
            function()
              require("neo-tree.sources.git_status").refresh()
            end
          '';
      };
    }
  ];

  keymaps = [{
    mode = "n";
    key = "<leader>e";
    action = "<cmd>Neotree toggle<cr>";
    options = { desc = "Toggle Neotree"; };
  }];
}
