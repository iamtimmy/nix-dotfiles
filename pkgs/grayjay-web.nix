{ buildNpmPackage, pkgs, ... }:
let
  grayjay = pkgs.callPackage ./grayjay.nix { };
in
buildNpmPackage {
  inherit (grayjay) version;
  pname = "grayjay-desktop-web";
  src = "${grayjay.src}/Grayjay.Desktop.Web";

  npmDepsHash = "sha256-pTEbMSAJwTY6ZRriPWfBFnRHSYufSsD0d+hWGz35xFM=";

  postBuild = "cp -r ./dist $out/";
  # fixupPhase = "rm -rf $out/lib";
}
