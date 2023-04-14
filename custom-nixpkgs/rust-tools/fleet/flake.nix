{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = {self, nixpkgs, naersk, utils, ...}:
  utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {inherit system; };
      naersk-lib = pkgs.callPackage naersk { };
    in
      {
        defaultPackage = naersk-lib.buildPackage {
          src = pkgs.fetchFromGitHub {
            owner = "dimensionhq";
            repo = "fleet";
            rev = "master";
            sha256 = "sha256-haXMQus+8ZLFY7BsHAPhplFLeg0iioLv6hVJVb/uAv8=";
          };
          doCheck = true;
          pname = "fleet";
          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
          buildInputs = with pkgs; [
            openssl
          ];
        };
        defaultApp = utils.lib.mkApp {
          drv = self.defaultPackage.${system};
        };
        devShell = with pkgs; mkShell {
          nativeBuildInputs = [
            pkg-config
          ];
          buildInputs = [
            openssl
            cargo
            rustc
          ];
          packages = [
            tokei
            rustPackages.clippy
            bacon
            rustfmt
          ];
        };
      });
}
