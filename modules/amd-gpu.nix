{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.amd-gpu-config;
in
{
  options.amd-gpu-config = {
    enable = mkEnableOption "Configure nixos system to support and early load amd GPU Drivers";
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];

    services.xserver.videoDrivers = [ "amdgpu" ];
    # systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

    # hardware.amdgpu.opencl.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        vaapiVdpau
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva-vdpau-driver
        libvdpau-va-gl
        vaapiVdpau
      ];
    };
  };
}

