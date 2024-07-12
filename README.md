# Nixvim Configuration

A standalone nixvim configuration. The entire neovim configuration is
externalized. You can run neovim configuration outside of NixOS configuration.
It can also be run outsie of NixOS altogether.

This configuration took heavy inspiration from the following:

- [Building a standalone nixvim
  configuration](https://gist.github.com/siph/288b7c6b5f68a1902d28aebc95fde4c5)
- [Nevo configuration](https://github.com/redyf/Neve)

Useful documentation and videos for creating nixvim:

- [Nixvim](https://github.com/nix-community/nixvim)
- [User Nixvim Configurations](https://nix-community.github.io/nixvim/user-guide/config-examples.html)
- [Nixvim Docs](https://nix-community.github.io/nixvim/)
- [Quick Setup Tutorial](https://www.youtube.com/watch?v=b641h63lqy0)
- [Configure Neovim with the Power of Nix](https://www.youtube.com/watch?v=GOe0C7Qtypk)

## Running

The configuration can be run from the project folder:

```bash
    nix run
```

The configuration can be run from the public repository using:

```bash
    nix run github:owejow/nixvim-config
```

## Notes

Would like to capture process of refining the neovim configuration file for learning purposes.

### Adding Live Grep Args to Telescope

The package [Live Grep Args](https://github.com/nvim-telescope/telescope-live-grep-args.nvim) enables passing
arguments to the grep command.

The package is not included in the nixvim module but is included in nixpkgs.
The file ./config/extra-plugins.nix contains the declaration to include the plugin:

```nix
    { pkgs, ... }: {
      extraPlugins = with pkgs.vimPlugins; [ telescope-live-grep-args-nvim ];
    }
```

The plugin now needs to be configured inside of telescope. The repository [Live Grep Args](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)
contains a sample configuration:

```lua
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup {
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- freeze the current list and start a fuzzy search in the frozen list
              ["<C-space>"] = actions.to_fuzzy_refine,
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        }
      }
    }

    -- don't forget to load the extension
    telescope.load_extension("live_grep_args")
```

This snippet was included via the extraConfigLua option inside of ./config/utils/telescope.nix

```nix
  extraConfigLua =
    # lua
    ''
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup {
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                -- freeze the current list and start a fuzzy search in the frozen list
                ["<C-space>"] = actions.to_fuzzy_refine,
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          }
        }
      }

      -- don't forget to load the extension
      telescope.load_extension("live_grep_args")
    '';
```

The keymap "<leader>/" is used to trigger the extension. Additional keybindings
inside the window can be defined inside the extraConfigLua declaration.

Todo: create a pull request for this plugin for [Nixvim](https://github.com/nix-community/nixvim)

### Adding Prettier Code Folding

Integrated the [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) plugin into
configuration. Nixvim natively supports this plugin. Added the file
./config/utils/nvim-ufo.nix. Used sample configuration provided in the repo as
a starting point. Folding is much prettier than the default nvim method.

- todo: understand how to configure LSP based folding rather than tree-sitter based folding.

- todo: get preview of code under fold to work as expected

- todo: explore custimizations for specifically used languages

### Customizing Color Scheme

Using the default catppuccin color scheme did not provide enough contrast for the
window separator options. The highlight command in vim is used to specify colors
for various parts of the editor.

The "highlight_overrides" key as added ./config/colorschemes/catppuccin.nix. More
examples on how to customize catppuccin inside neovim can be found at: [Catppuccin Neovim](https://github.com/catppuccin/nvim)

```lua
    highlight_overrides = {
      all = {
        __raw =
          # lua
          ''
            function(colors)
              return {
                  WinSeparator = { fg = colors.surface2 }
                }
            end
          '';
      };
    };

```

The color palletes for the various catppuccin themes can be found at:
[Catppuccin Palette](https://catppuccin.com/palette)

### Adding Custom LSP Support

There is no Solidity lsp configured for nixvim. In order to add support for
Solidity development we can add support for [vscode-solidity-server](https://github.com/juanfranblanco/vscode-solidity)

1. Create a derivation for the language server

   - We can do this using `buildNpmPackage`

   ```nix
    buildNpmPackage rec {
      name = "vscode-solidity";
      buildInputs = lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.Security
        darwin.apple_sdk.frameworks.AppKit
      ];
      src = fetchFromGitHub {
        owner = "juanfranblanco";
        repo = name;
        rev = "39efb5e17efdc1f18e57d1243617110a449b662c";
        hash = "sha256-dVHgXRq0hMWQiMqvsQ15pn06rPbPkCZkv0m9j6EZ0EQ=";
      };

      npmBuildScript = "build:cli";
      npmDepsHash = "sha256-h3PVqxIzOLUl80INF/q68N8pEa27GcucD41h/tekvOU=";

      meta = {
        description = "A Solidity lsp";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    }

   ```

2. Configure the lsp module to use this language server

   - Copy The mk-lsp.nix script from the lsp module fetchFromGitHub (maybe there is a better way to do this)
   - call mkLsp on the derivation defined above

   ```nix
   { pkgs, lib, config, ... }: {
      imports =
        let mkLsp = import ./helpers/mk-lsp.nix { inherit lib config pkgs; };
        in [
          (mkLsp {
            name = "vscode-solidity-server";
            description = "LSP for Solidity";
            package = pkgs.callPackage ./servers/solidity.nix { };
            cmd = cfg: [ "vscode-solidity-server" "--stdio" ];
          })

        ];
    }

   ```

3. Configure neovim lspconfig to recognize the custom lsp

### Debugging Neovim

Some useful tips for debugging neovim issues:

```lua
    -- prints currently loaded packages
    vim.print(package.loaded)
```

```lua
    -- The runtime path for a nixvim is quite long
    vim.print(vim.api.nvim_list_runtime_paths())
```
