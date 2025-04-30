{ config, lib, pkgs, systemSettings, ... }:

{
  config = {
    nixpkgs.hostPlatform = systemSettings.system;

    environment.systemPackages = with pkgs; [ nh ];
  };
}
