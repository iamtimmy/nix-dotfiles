# gpuconfig.nix

{ config, lib, pkgs, inputs, ... }:

with lib;
let

in
{
  options = {
    gpuconfig.useNvidia = mkOption {
      type = types.bool;
      default = false;
      description = "use nvidia gpu and add amd to the blacklist";
    };
    gpuconfig.useAmd = mkOption {
      type = types.bool;
      default = false;
      description = "use amd gpu and add nvidia to the blacklist";
    };
  };
  
  config = {
  };
}
