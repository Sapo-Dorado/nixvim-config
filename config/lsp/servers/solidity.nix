{ lib, buildNpmPackage, fetchFromGitHub, stdenv, darwin }:

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
