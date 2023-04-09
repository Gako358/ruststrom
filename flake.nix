{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    maelstrom-src = {
      url = "https://github.com/jepsen-io/maelstrom/releases/download/v0.2.3/maelstrom.tar.bz2";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    naersk,
    maelstrom-src,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        naersk-lib = pkgs.callPackage naersk {};
      in {
        packages = {
          maelstrom = pkgs.stdenv.mkDerivation {
            name = "maelstrom";
            src = maelstrom-src;
            buildInputs = with pkgs; [bzip2];

            unpackPhase = ''
              tar -xjf $src
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp maelstrom $out/bin/maelstrom
              chmod +x $out/bin/maelstrom
            '';
          };
        };
        devShell = let
          maltest = pkgs.writeShellScriptBin "maltest" ''
            maelstrom test -windowed echo --bin ./target/debug/echo --node-count 1 --time-limit 10
          '';
        in
          pkgs.mkShell {
            name = "maelstrom-dev";
            buildInputs = with pkgs; [
              cargo
              rustc
              rustfmt
              pre-commit
              rustPackages.clippy
              pkg-config
              maelstrom
              maltest
            ];
          };
      }
    );
}
