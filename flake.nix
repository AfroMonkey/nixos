{
  description = "afroflake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.*";
    # fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # fh,
    # lanzaboote,
    ...
  } @ inputs: {
    nixosConfigurations.afroframe = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.disko.nixosModules.default
        (import ./disko.nix {device = "/dev/nvme0n1";})
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.moy = import ./home.nix;
        }
        # fh.packages.x86_64-linux.default
        # lanzaboote.nixosModules.lanzaboote
        # ({
        #   pkgs,
        #   lib,
        #   ...
        # }: {
        #   environment.systemPackages = [
        #     # For debugging and troubleshooting Secure Boot.
        #     pkgs.sbctl
        #   ];

        #   # Lanzaboote currently replaces the systemd-boot module.
        #   # This setting is usually set to true in configuration.nix
        #   # generated at installation time. So we force it to false
        #   # for now.
        #   boot.loader.systemd-boot.enable = lib.mkForce false;

        #   boot.lanzaboote = {
        #     enable = true;
        #     pkiBundle = "/var/lib/sbctl";
        #   };
        # })
      ];
    };
  };
}
