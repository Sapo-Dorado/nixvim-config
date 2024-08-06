{
  globals.mapleader = " ";
  keymaps = [
    {
      key = "<leader>-";
      action = "<C-W>s";
      options.desc = "Split Window Below";
    }
    {
      key = "<leader>|";
      action = "<C-W>v";
      options.desc = "Split Window Right";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>qa<cr>";
      options.desc = "Quit";
    }
    {
      mode = "t";
      key = "<C-n>";
      action = "<c-\\><c-n>";
      options.desc = "Enter Normal Mode";
    }

    # LazyVim better up and down
    {
      mode = [ "n" "x" ];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";

      options = {
        expr = true;
        silent = true;
        desc = "Down";
      };
    }
    {
      mode = [ "n" "x" ];
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";

      options = {
        expr = true;
        silent = true;
        desc = "Down";
      };
    }
    {
      mode = [ "n" "x" ];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";

      options = {
        expr = true;
        silent = true;
        desc = "Up";
      };
    }
    {
      mode = [ "n" "x" ];
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";

      options = {
        expr = true;
        silent = true;
        desc = "Up";
      };
    }
  ];
}
