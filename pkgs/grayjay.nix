{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitLab,
  callPackage,

  libz,
  icu,
  openssl,

  xorg,

  gtk3,
  glib,
  nss,
  nspr,
  dbus,
  atk,
  cups,
  libdrm,
  expat,
  libxkbcommon,
  pango,
  cairo,
  udev,
  alsa-lib,
  mesa,
  libGL,
  libsecret,
}:
let
  grayjay-web = callPackage ./grayjay-web.nix {};
in
buildDotnetModule {
  pname = "grayjay-desktop";
  version = "0-unstable-2025-16-01";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "VideoStreaming";
    repo = "Grayjay.Desktop";
    rev = "08d8f13cc2e3effe8c54106fc3ee7fdd27ef9547";
    hash = "sha256-M1/RpaAse9Kzizpmgxbrnzh37vriKKigM0sdrLX3BBM=";
    fetchSubmodules = true;
    fetchLFS = true;
  };

  patches = [ ./grayjay.patch ];

  executables = "Grayjay";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  nugetDeps = ./grayjay_deps.json;
  projectFile = "Grayjay.Desktop.CEF/Grayjay.Desktop.CEF.csproj";

  postInstall = ''
    rm $out/lib/grayjay-desktop/Portable
    mkdir -p $out/lib/grayjay-desktop/wwwroot
    ln -s ${grayjay-web} $out/lib/grayjay-desktop/wwwroot/web
  '';

  runtimeDeps = [
    libz
    icu
    openssl # For updater

    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb

    gtk3
    glib
    nss
    nspr
    dbus
    atk
    cups
    libdrm
    expat
    libxkbcommon
    pango
    cairo
    udev
    alsa-lib
    mesa
    libGL
    libsecret
  ];

  meta = {
    mainProgram = "Grayjay";
  };
}

