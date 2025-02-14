{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation {
  pname = "universal-pidff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JacKeTUs";
    repo = "universal-pidff";
    rev = "b1785f9ab4b7f43b8e886734b346b994933a3f72";
    hash = "sha256-7leE44Z0MvINiQY192lVo0ZaWJ+cs6v3OKpzMlDtBPI=";
  };

  postPatch = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  installTargets = [ "install" ];

  meta = {
    description = "PIDFF driver with useful patches for initialization of FFB devices";
    homepage = "https://github.com/JacKeTUs/universal-pidff";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      computerdane
      racci
    ];
    platforms = lib.platforms.linux;
  };
}
