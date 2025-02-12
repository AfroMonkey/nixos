{
  description = "afroflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2411.*";
    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/0.5.2.tar.gz";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/0.1.21.tar.gz";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lan-mouse.url = "github:feschber/lan-mouse";
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote/v0.4.2";

    #   # Optional but recommended to limit the size of your system closure.
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    fh,
    nix-flatpak,
    nixos-hardware,
    plasma-manager,
    disko,
    lan-mouse,
    ...
  } @ inputs: {
    nixosConfigurations.afroframe = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.framework-16-7040-amd
        {
          environment.systemPackages = [fh.packages.x86_64-linux.default];
        }
        inputs.disko.nixosModules.default
        (import ./disko.nix {device = "/dev/nvme0n1";})
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.moy = import ./home.nix;
          home-manager.sharedModules = [plasma-manager.homeManagerModules.plasma-manager];
        }
        nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  };
}
