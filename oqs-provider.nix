{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  liboqs,
  enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "oqs-provider";
  name = "oqsprovider";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = pname;
    rev = version;
    sha256 = "sha256-KKZMb6ebaXxLSr5aV0m0VIHj2ofaRYQ0JF5JMAfiEj4=";
  };

  nativeBuildInputs = [ cmake openssl liboqs ];
  buildInputs = [  ];

  cmakeFlags = [
    "-DOQS_PROVIDER_BUILD_STATIC=${if enableStatic then "ON" else "OFF"}"
    "-DOQS_DIST_BUILD=ON"
    "-DOQS_BUILD_ONLY_LIB=ON"
  ];

  installPhase = ''
    mkdir -p $out/lib/ossl-modules
    cp lib/* $out/lib/ossl-modules
  '';

  dontFixCmake = true; # fix CMake file will give an error

  meta = with lib; {
    description = "C library for prototyping and experimenting with quantum-resistant cryptography";
    homepage = "https://openquantumsafe.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [];
  };
}
