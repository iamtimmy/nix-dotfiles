{ pkgs, ... }:

{
  home.packages = with pkgs; [
    llvmPackages.libcxxClang
    libcxx
    libgcc
    gnumake
    ninja
    cmake
    zig
    zls
  ];
}
