{
  lib,
  # stdenv,
  fetchFromGitHub,
  fetchPypi,
  # python3,
  python3,

  # setuptools,

  gtk4,
  libadwaita,
  glib,

  wrapGAppsHook4,
  gobject-introspection,
}:

let
  pypkg-overrides = [
    (self: super: {
      psutil = super.psutil.overridePythonAttrs (oldAttrs: rec {
        pname = "psutil";
        version = "0.6.1";
        src = fetchPypi {
          inherit version pname;
          hash = "sha256-UuunlSgc3RB58T3taoUfbQKVUd31Uurcmi7j6yb+mU0=";
        };
      });
    })
  ];

  python = python3.override {
    self = python3;
    packageOverrides = lib.composeManyExtensions pypkg-overrides;
  };

in
# extraBuildInputs = python.pkgs;
python.pkgs.buildPythonApplication rec {
  pname = "boxflat";
  version = "1.25.2";

  src = fetchFromGitHub {
    owner = "lawstorant";
    repo = "boxflat";
    rev = version;
    sha256 = "sha256-EB4Q8BeTZTmjfA+LRUUHdTBxoH+RpOroZZFmsbDk49U=";
  };

  pyproject = true;

  build-system = with python.pkgs; [
    setuptools
    setuptools-scm
  ];

  # dependencies = [
  #   setuptools
  # ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  propagatedBuildInputs = with python.pkgs; [
    gtk4
    libadwaita
    glib

    pygobject3
    pyyaml
    pyserial
    pycairo
    psutil
    evdev
  ];

  preBuild = ''
    cat > setup.py << EOF
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    setup(
      name='boxflat',
      packages=['boxflat', 'boxflat.panels', 'boxflat.widgets'],
      version='${version}',
      install_requires=install_requires,
      entry_points={
        # example: file some_module.py -> function main
        'console_scripts': ['boxflat=boxflat.entrypoint:main']
        # 'console_scripts': [
        #   'boxflat=boxflat.entrypoint'
        # ]
      },
    )
    EOF
  '';

  # checkPhase = ''
  #   runHook preCheck
  #   ${python3.interpreter} -m unittest
  #   runHook postCheck
  # '';

  preInstall = ''
    mkdir -p "$out/usr/share/boxflat"
    cp -r ./data "$out/usr/share/boxflat/"
  '';

  # postInstall = ''
  #   wrapProgram "$out/bin/boxflat"\
  #     --set BOXFLAT_FLATPAK_EDITION false\
  #     --add-flags "--data-path $out/usr/share/boxflat/data"
  # '';

  # postInstall = ''
  #   makeWrapper ${python}/bin/python $out/bin/boxflat \
  #     --add-flags "$out/lib/python${python.pythonVersion}/site-packages/boxflat/entrypoint.py --data-path $out/share/boxflat/data"
  # '';

  meta = with lib; {
    homepage = "https://github.com/Lawstorant/boxflat";
    changelog = "https://github.com/Lawstorant/boxflat/releases/tag/${version}";
    description = "Boxflat for Moza Racing. Control your Moza gear settings!";
    mainProgram = "boxflat";
    license = licenses.gpl3;
    maintainers = [ maintainers.jensereal ];
    platforms = platforms.unix;
  };
}

# let
#   version = "v1.25.2";
#   python = python3.withPackages (
#     p: with p; [
#       pygobject3
#       evdev
#       gtk4

#       pyyaml
#       psutil
#       pyserial
#       pycairo
#     ]
#   );
# in
# stdenv.mkDerivation {
#   inherit version;
#   pname = "boxflat";
#   src = fetchFromGitHub {
#     owner = "lawstorant";
#     repo = "boxflat";
#     rev = version;
#     sha256 = "sha256-EB4Q8BeTZTmjfA+LRUUHdTBxoH+RpOroZZFmsbDk49U=";
#   };

#   format = "setuptools";

#   nativeBuildInputs = [
#     wrapGAppsHook4
#     gobject-introspection
#   ];

#   propagatedBuildInputs = [
#     gtk4
#     libadwaita
#     python3Packages.pygobject3
#     python3Packages.pyyaml
#     python3Packages.pyserial
#     python3Packages.pycairo
#   ];

#   preBuild = ''
#     cat > setup.py << EOF
#     from setuptools import setup

#     with open('requirements.txt') as f:
#         install_requires = f.read().splitlines()

#     setup(
#       name='boxflat',
#       packages=['boxflat', 'boxflat.panels', 'boxflat.widgets'],
#       version='${version}',
#       install_requires=install_requires,
#       entry_points={
#         # example: file some_module.py -> function main
#         'console_scripts': ['boxflat=boxflat.entrypoint:main']
#       },
#     )
#     EOF
#   '';

#   checkPhase = ''
#     runHook preCheck
#     ${python3.interpreter} -m unittest
#     runHook postCheck
#   '';

#   preInstall = ''
#     mkdir -p "$out/usr/share/boxflat"
#     cp -r ./data "$out/usr/share/boxflat/"
#   '';

#   postInstall = ''
#     wrapProgram "$out/bin/boxflat" --add-flags "--data-path $out/usr/share/boxflat/data"
#   '';

#   # installPhase = ''
#   #   # Create necessary directories
#   #   mkdir -p $out/bin

#   #   mkdir -p $out/lib/python${python.pythonVersion}/site-packages/boxflat
#   #   mkdir -p $out/lib/udev/rules.d
#   #   # mkdir -p $out/share/boxflat/data

#   #   # Copy all project files to site-packages
#   #   cp -r ./* $out/lib/python${python.pythonVersion}/site-packages/boxflat/

#   #   # Install the data folder to the correct location
#   #   mkdir -p $out/share/boxflat/data
#   #   cp -r data/* $out/share/boxflat/data/

#   #   # Install udev rules
#   #   cp udev/99-boxflat.rules $out/lib/udev/rules.d/99-boxflat.rules

#   #   # Create wrapper script
#   #   makeWrapper ${python}/bin/python $out/bin/boxflat \
#   #     --add-flags "$out/lib/python${python.pythonVersion}/site-packages/boxflat/entrypoint.py --data-path $out/share/boxflat/data"
#   # '';

#   meta = with lib; {
#     homepage = "https://github.com/Lawstorant/boxflat";
#     changelog = "https://github.com/Lawstorant/boxflat/releases/tag/${version}";
#     description = "Boxflat for Moza Racing. Control your Moza gear settings!";
#     mainProgram = "boxflat";
#     license = licenses.gpl3;
#     maintainers = [ maintainers.jensereal ];
#     platforms = platforms.unix;
#   };
# }
