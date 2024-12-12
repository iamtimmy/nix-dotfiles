{ config, pkgs, ... }:

let
  hid-tmff2 = config.boot.kernelPackages.callPackage ../pkgs/hid-tmff2.nix { };
  oversteer = pkgs.callPackage ../pkgs/oversteer.nix { };
in
{
  boot.blacklistedKernelModules = [ "hid-thrustmaster" ];
  boot.extraModulePackages = [ hid-tmff2 ];
  boot.kernelModules = [ "hid-tmff2" ];

  environment.systemPackages = with pkgs; [
    oversteer

    opentrack
    aitrack
  ];

  services.udev.packages = [ oversteer ];
}
