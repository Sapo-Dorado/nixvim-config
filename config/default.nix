{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./colorschemes/catppuccin.nix
    ./colorschemes/tokyonight.nix

    ./bufferline.nix
    ./cmp.nix
    ./git.nix
    ./lightline.nix

    ./languages/treesitter.nix
    ./languages/treesitter-context.nix
    ./languages/rainbow-delimiters.nix

    ./lsp/default.nix
    ./lsp/fidget.nix
    ./lsp/none-ls.nix
    ./lsp/trouble.nix

    ./utils/auto-pairs.nix
    ./utils/autosave.nix
    ./utils/blankline.nix
    ./utils/lazygit.nix
    ./utils/telescope.nix
    ./utils/toggleterm.nix
    ./utils/which-key.nix
    ./utils/wilder.nix
    ./utils/neo-tree.nix
  ];
}
