{
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    extensions = [ "neo-tree" "quickfix" "toggleterm" ];
    sections = {
      lualine_a = [ "mode" ];
      lualine_b = [ "branch" ];
      lualine_c = [
        {
          name = "filetype";
          extraConfig = {
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          };
        }
        {
          name = "filename";
          extraConfig = { path = 1; };
        }

      ];
      lualine_x = [
        # lua
        ''
          require("noice").api.status.command.get()
        ''
        # lua
        ''
          (vim.fn.reg_recording() == "" and "") or "Recording @" .. vim.fn.reg_recording()
        ''
        {
          name = "diff";
          extraConfig = {
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
            source =
              # lua
              ''
                function()
                   local gitsigns = vim.b.gitsigns_status_dict
                   if gitsigns then
                     return {
                       added = gitsigns.added,
                       modified = gitsigns.changed,
                       removed = gitsigns.removed,
                     }
                   end
                 end
              '';
          };
        }
      ];
      lualine_y = [
        {
          name = "progress";
          extraConfig = {
            separator = " ";
            padding = {
              left = 1;
              right = 0;
            };
          };
        }
        {
          name = "location";
          extraConfig = {
            padding = {
              left = 0;
              right = 1;
            };
          };
        }
      ];
      lualine_z = [
        # lua
        ''
          " " .. os.date("%R")
        ''
      ];
    };
  };
}
