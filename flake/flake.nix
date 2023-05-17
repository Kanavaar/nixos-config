{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, fenix, home-manager, emacs-overlay }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, lib, ... }: { nix.registry.nixpkgs.flake = nixpkgs; })
          { nixpkgs.overlays = [ fenix.overlays.default emacs-overlay.overlays.default ]; }
          ./hosts
          ./hosts/tilman.nix
          #    home-manager.nixosModule.home-manager {
          #      home-manager.useGlobalPkgs = true;
          #      home-manager.useUserPackages = true;
          #      home-manager.users.tilman = import ./home/tilman.nix;
          #    }
        ];
      };
    };
    devShells.x86_64-linux.default = with nixpkgs.legacyPackages.x86_64-linux; mkShell {
      packages = [
        just
      ];
    };
  };
}
