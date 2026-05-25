{
  description = "GraphWalker Rust developer environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # Rust toolchain
            rustc
            cargo
            rustfmt
            clippy
            rust-analyzer

            # Node.js for frontend studio development
            nodejs
            
            # Standard dependencies that cargo packages might compile against
            pkg-config
            openssl
          ];

          # Set up environment variables
          PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

          shellHook = ''
            echo "=========================================================="
            echo "  GraphWalker Rust Development Environment (Nix)"
            echo "  - Rust version:   $(rustc --version 2>/dev/null || echo 'Not installed')"
            echo "  - Cargo version:  $(cargo --version 2>/dev/null || echo 'Not installed')"
            echo "  - Node version:   $(node --version 2>/dev/null || echo 'Not installed')"
            echo ""
            echo "  Useful commands:"
            echo "    cargo build           - Build the Rust workspace"
            echo "    cargo test            - Run all tests"
            echo "    cargo run -p graphwalker-cli -- --help  - Run the CLI"
            echo "=========================================================="
          '';
        };
      });
    };
}
