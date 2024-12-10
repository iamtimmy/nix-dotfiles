{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.nvidia-gpu;
in
{
  options.nvidia-gpu = {
    enable = mkEnableOption "Configure nixos system to support and early load Nvidia GPU Drivers";
  };

  config = mkIf cfg.enable {
    environment.Sessionvariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_TYPE_LIBRARY_NAME = "nvidia";
    };

    boot.initrd.kernelModules = [ "nvidia" ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        vaapiVdpau
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        vaapiVdpau
      ];
    };
  };
}

