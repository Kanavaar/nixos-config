{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, fenix, crane, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        rustToolchain = fenix.packages.${system}.fromToolchainFile {
          dir = ./.;
          sha256 = pkgs.lib.fakeSha256;
        };

        craneLib = crane.lib.${system}.overrideToolchain rustToolchain;
        your-app = craneLib.buildPackage {
          src = craneLib.cleanCargoSource (craneLib.path ./.);

          buildInputs = [
            # Add additional build inputs here
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            # Additional darwin specific inputs can be set here
            pkgs.libiconv
          ];
        };
      in
      {
        checks = {
          inherit your-app;
        };

        package.default = your-app;

        app.default = flake-utils.lib.mkApp {
          drv = your-app;
        };

        devShell.default = pkgs.mkShell {
          inputsFrom = builtins.attrValues self.checks.${system};

          nativeBuildInputs = with pkgs; [
            rustToolchain
          ];
        };
      });
}
