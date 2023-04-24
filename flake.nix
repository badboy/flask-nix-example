{
  description = "flask-example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };
        bin = pkgs.poetry2nix.mkPoetryApplication {
          projectDir = ./.;
        };
        dockerImage = pkgs.dockerTools.buildImage {
          name = "flask-example";
          tag = "latest";
          copyToRoot = [ bin ];
          config = {
            Cmd = [ "${bin}/bin/app" ];
          };
        };
      in with pkgs; rec {
        # Development environment
        devShells.default = mkShell {
          name = "flask-example";
          nativeBuildInputs = [ python3 poetry ];
          inputsFrom = [ bin ];
        };

        packages = {
          inherit bin dockerImage;
          default = bin;
        };
      }
    );
}
