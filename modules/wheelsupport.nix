{ config, pkgs, ... }:

let
  hid-tmff2 = config.boot.kernelPackages.callPackage ../pkgs/hid-tmff2.nix { };
  oversteer = pkgs.callPackage ../pkgs/oversteer.nix { };

  universal-pidff = config.boot.kernelPackages.callPackage ../pkgs/universal-pidff.nix { };
  boxflat = pkgs.callPackage ../pkgs/boxflat_old.nix { };
in
{
  boot.blacklistedKernelModules = [ "hid-thrustmaster" ];
  boot.extraModulePackages = [ hid-tmff2 universal-pidff ];
  boot.kernelModules = [ "hid-tmff2" "universal-pidff" ];

  environment.systemPackages = with pkgs; [
    oversteer
    boxflat

    opentrack
    aitrack
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", KERNEL=="ttyACM*", ATTRS{idVendor}=="346e", ACTION=="add", MODE="0666", TAG+="uaccess"
  '';

  services.udev.packages = [ oversteer ];
}
