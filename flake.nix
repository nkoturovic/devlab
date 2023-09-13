{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.zig = {
    url = "github:mitchellh/zig-overlay";
  };
  inputs.koturNixPkgs = {
    url = "github:nkoturovic/kotur-nixpkgs/v0.5";
    flake = false;
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    zig,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      shell = import ./shell.nix {inherit system pkgs;};
    in {
      devShells.default = shell;
      formatter = pkgs.alejandra;
    });
}
