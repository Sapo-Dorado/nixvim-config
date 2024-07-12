{
  imports = [
    ./extra-plugins.nix
    ./options.nix
    ./keymaps.nix
    ./colorschemes/catppuccin.nix

    ./lualine.nix
    ./cmp.nix
    ./git.nix

    ./languages/treesitter.nix
    ./languages/treesitter-context.nix
    ./languages/rainbow-delimiters.nix

    ./lsp/configure-servers.nix
    ./lsp/default.nix
    ./lsp/none-ls.nix
    ./lsp/trouble.nix

    ./utils/auto-pairs.nix
    ./utils/blankline.nix
    ./utils/bufferline.nix
    ./utils/lazygit.nix
    ./utils/neo-tree.nix
    ./utils/noice.nix
    ./utils/notify.nix
    ./utils/nvim-ufo.nix
    ./utils/telescope.nix
    ./utils/toggleterm.nix
    ./utils/which-key.nix

  ];
}
