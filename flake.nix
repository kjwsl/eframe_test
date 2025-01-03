{
  description = "Development environment with Rust 1.81 and necessary dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Optionally, use flake-utils for easier flake definitions
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # Optionally, specify any additional configuration or overlays here
        };

        # Define the library path
        libPath = pkgs.lib.makeLibraryPath [
          pkgs.libGL
          pkgs.libxkbcommon
          pkgs.wayland
        ];

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.cargo
            pkgs.rustc
            pkgs.rust-analyzer
            # Add any other dependencies you need
          ];

          # Set environment variables
          shellHook = ''
            export RUST_LOG="debug"
            export RUST_SRC_PATH="${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}"
            export LD_LIBRARY_PATH="${libPath}"
          '';

          # Alternatively, set environment variables directly
          # RUST_LOG = "debug";
          # RUST_SRC_PATH = "${rust.rustPlatform.rustLibSrc}";
          # LD_LIBRARY_PATH = libPath;
        };
      }
    );
}

