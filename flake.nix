{
  description = "My Nix Config";
  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    dotfiles = {
      url = "github:sleepyswords/dotfiles";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.homelab-unit00 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/homelab-unit00
          ./modules/nixos/grafana.nix
          ./modules/nixos/k3.nix
          ./modules/nixos/deploy.nix
          ./modules/nixos/sops.nix
          ./modules/nixos/docker.nix
          ./modules/nixos/nginx.nix
          ./modules/nixos/cloudflared.nix
          ./modules/nixos/prometheus.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.swords = import ./home/server.nix;
          }
        ];
      };
      darwinConfigurations.macbook = darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/macbook.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.ibby = import ./home/personal.nix;
          }
        ];
      };
      darwinConfigurations.homelab-unit01 = darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/homelab-unit01.nix
          ./modules/darwin/prometheus.nix
        ];
      };
    };
}
