{ stdenv, lib, fetchFromGitHub, kernel }:

# I end up having to have this on file because we change kernel versions often and this package is not updated very often upstream

stdenv.mkDerivation {
	pname = "hid-tmff2";
	version = "unstable-2024-12-8";

	src = fetchFromGitHub {
		owner = "Kimplul";
		repo = "hid-tmff2";
		rev = "d6ae229bc8c84dcef300498a6c8649837e2df636";
		hash = "sha256-WPXTauHH/xPspcPDl/9qfgL+GJ5yahdq8Hxt7hrzsF4=";
		fetchSubmodules = true;
	};

	nativeBuildInputs = kernel.moduleBuildDependencies; 

	makeFlags = kernel.makeFlags ++ [
		"KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
	];

	installFlags = [
		"INSTALL_MOD_PATH=${placeholder "out"}"
	];
  
	postPatch = "sed -i '/depmod -A/d' Makefile";

	meta = with lib; {
		description = "A linux kernel module for Thrustmaster T300RS and T248";
		homepage = "https://github.com/Kimplul/hid-tmff2";
		license = licenses.gpl2Plus;
		maintainers = [ maintainers.rayslash ];
		platforms = platforms.linux;
	};
}
