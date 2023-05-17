{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    disko = {
      url = "github:nix-community/disko";
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
  outputs = { self, nixpkgs, fenix, disko, emacs-overlay }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, lib, ... }: { nix.registry.nixpkgs.flake = nixpkgs; })
          { nixpkgs.overlays = [ fenix.overlays.default emacs-overlay.overlays.default ]; }
          ./hosts
          ./hosts/tilman.nix
          ./hardware
          disko.nixosModules.disko
          (import ./hardware/disks.nix {
            disks = ["/dev/vda"];
          })
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
