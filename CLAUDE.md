# NixVim Config — Claude Context

A Nix flake that configures Neovim declaratively using [nixvim](https://nix-community.github.io/nixvim/).

- Run: `nix run .`
- Check: `nix flake check .`
- Docs: https://nix-community.github.io/nixvim/

## Architecture

### Flake (flake.nix)
- Inputs: `nixpkgs` (unstable), `nixpkgs-stable` (25.05), `nixvim`, `flake-parts`
- Multi-system via `flake-parts`: x86_64/aarch64 linux+darwin
- `nixpkgs-stable` passed as `extraSpecialArgs` — used in `packages.nix` and `lint/default.nix`

### Config Module (config/default.nix)
Auto-imports every subdirectory of `./plugins/`, plus:
- `./autocmd` — autocommands via Lua
- `./diagnostics.nix` — diagnostic display settings
- `./helpers` — runtime Lua files via `extraFiles`
- `./lsp` — LSP servers and keymaps
- `./keymaps.nix` — global keymaps
- `./options.nix` — vim options and globals
- `./packages.nix` — `extraPackages` (system tools)

**To add a new plugin:** create `config/plugins/<name>/default.nix` — it's auto-imported.

## Key NixVim Patterns

### Enabling plugins
```nix
plugins.<name>.enable = true;
plugins.<name>.settings = { ... };  # becomes require('name').setup({})
```

### Raw Lua in Nix
```nix
action.__raw = "function() ... end";          # inline Lua value
extraConfigLua = lib.readFile ./file.lua;     # load external Lua file
"__rawKey__vim.diagnostic.severity.ERROR"     # Lua expression as attrset key
__unkeyed-1 = "value";                        # positional value in mixed table
```

### Dropping files into Neovim runtime
```nix
extraFiles."lua/my-helper.lua".source = ./my-helper.lua;
# Accessible as require('my-helper') in Lua
```

### Keymaps (three styles)
```nix
# 1. Global list (keymaps.nix)
keymaps = [{ key = "<leader>x"; action = "..."; options.desc = "..."; mode = "n"; }];

# 2. Plugin-specific
plugins.fzf-lua.keymaps."<leader>ff" = { action = "files"; options.desc = "..."; };

# 3. LSP buf
plugins.lsp.keymaps.lspBuf."gd" = "definition";
```

### Using nixpkgs-stable in a module
```nix
{ nixpkgs-stable, ... }:
let pkgs = nixpkgs-stable; in
{ extraPackages = [ pkgs.biome ]; }
```

### Conditional packages
```nix
{ config, lib, pkgs, ... }: {
  extraPackages = lib.mkIf config.plugins.blink-cmp.enable (with pkgs; [ curl git ]);
}
```

### Unsupported plugins (not in nixvim)
```nix
extraPlugins = with pkgs.vimPlugins; [ some-plugin-nvim ];
extraConfigLua = ''require('some-plugin').setup({})'';
```

## Installed Plugins

| Category | Plugins |
|----------|---------|
| Completion | blink-cmp (lsp/buffer/snippets/emoji/nerdfont/path), luasnip, friendly-snippets, blink-emoji |
| Syntax | treesitter, treesitter-textobjects, treesitter-context, rainbow-delimiters |
| LSP | lsp, inc-rename, lsp-lines, lazydev |
| Formatting | conform-nvim (format on save) |
| Linting | nvim-lint (lint on BufEnter/BufWritePost/InsertLeave) |
| Colorscheme | catppuccin (mocha dark, macchiato light) |
| UI | lualine, bufferline, noice, notify, dressing, blankline, nvim-colorizer, mini-icons |
| Navigation | fzf-lua, nvim-tree, oil, toggleterm, lazygit |
| Git | gitsigns (via `git/`) |
| Editing | auto-pairs, nvim-surround, nvim-ufo (folding), trouble |
| Language | rustaceanvim, markview (disabled) |
| Utility | which-key, nui |

## LSP Servers
bashls, cssls, clangd, elixirls, gopls, html, lua_ls, jsonls, marksman, nixd, pyright, ruff, slint_lsp, tailwindcss, ts_ls, yamlls, zls

## LSP Keymaps
`gd`=definition, `gr`=references, `gD`=declaration, `gT`=type_definition, `gi`=implementation, `K`=hover, `<leader>cm`=format, `<leader>cr`=rename, `<leader>ca`=code_action, `<C-s>`=signature_help

## vim Options
- Leader: `<Space>`
- 2-space indent (expandtab)
- Relative line numbers, `scrolloff=4`
- `clipboard=unnamedplus`, `swapfile=false`, `undofile=true`
- `foldlevelstart=99` (all folds open by default)
- `termguicolors` forced true on Linux only

## Which-key Groups
`<leader>b`=Buffers, `<leader>g`=Git, `<leader>f`=Find, `<leader>r`=Refactor, `<leader>u`=UI/UX, `<leader>x`=Diagnostic

## Special Notes
- Slint filetype registered via autocmd (`.slint` → `slint`)
- `nixpkgs-stable` used for most tool packages; `nixpkgs` (unstable) for nixvim itself
- `lib.getExe` / `lib.getExe'` used to pin linter/formatter binaries to Nix store paths
- Biome formatter has inline JSON config generated via `pkgs.writeTextFile`
- Autoformat disabled per-buffer: `vim.b.disable_autoformat = true`; globally: `vim.g.disable_autoformat = true`
