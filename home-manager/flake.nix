{
  description = "Flake of Maciek";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixgl.url = "github:nix-community/nixGL";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
      homeConfigurations.${userSettings.username} = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };
      systemConfigs.${systemSettings.hostname} = inputs.system-manager.lib.makeSystemConfig {
        modules = [ ./system.nix ];
        extraSpecialArgs = {
          inherit systemSettings;
          inherit inputs;
        };
      };
    };
}
