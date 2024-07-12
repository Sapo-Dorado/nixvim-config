{ pkgs, solidity, ... }: {
  extraPlugins = with pkgs.vimPlugins; [ telescope-live-grep-args-nvim ];
  extraPackages = [ pkgs.ripgrep pkgs.fd solidity ];
}
