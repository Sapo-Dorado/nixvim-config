{
  plugins.snacks = {
    enable = true;
    settings = {
      bufdelete.enabled = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>bd";
      action.__raw = "function() Snacks.bufdelete() end";
      options.desc = "Delete Buffer";
    }
  ];
}
