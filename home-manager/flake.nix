{
  description = "Flake of Maciek";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, ... }:
    let
      systemSettings = {
        hostname = "maciek-x1";
        system = "x86_64-linux";
      };

      userSettings = {
        username = "maciek";
        homeDirectory = "/home/maciek";
      };

      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [ inputs.nixgl.overlay ];
      };
    in {
      homeConfigurations.${userSettings.username} =
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix inputs.stylix.homeModules.stylix ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };

      systemConfigs.${systemSettings.hostname} =
        inputs.system-manager.lib.makeSystemConfig {
          modules = [ ./system.nix ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit inputs;
          };
        };
    };
}
