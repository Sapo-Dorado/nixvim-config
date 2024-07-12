{ pkgs, lib, config, solidity, ... }: {
  imports =
    let mkLsp = import ./helpers/mk-lsp.nix { inherit lib config pkgs; };
    in [
      (mkLsp {
        name = "solidity-ls";
        serverName = "solidity_ls";
        description = "LSP for Solidity";
        package = solidity;
        # cmd = cfg: [ "vscode-solidity-server" "--stdio" ];
      })

    ];
}
