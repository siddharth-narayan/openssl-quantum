{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, liboqs
, enableStatic ? stdenv.hostPlatform.isStatic
, ...
}:

stdenv.mkDerivation rec {
  pname = "oqs-provider";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = pname;
    rev = version;
    sha256 = "sha256-Uh7tMJefB2XumAgEIB8jGDVa/DEmk2BIBYikw4UqdX0=";
  };

  nativeBuildInputs = [ cmake openssl liboqs ];
  buildInputs = [  ];

  cmakeFlags = [
    # "-DBUILD_SHARED_LIBS=${if enableStatic then "OFF" else "ON"}"
    "-DOQS_PROVIDER_BUILD_STATIC=${if enableStatic then "ON" else "OFF"}"
    "-DOQS_DIST_BUILD=ON"
    "-DOQS_BUILD_ONLY_LIB=ON"
  ];

  installPhase = ''
    echo hi!
    mkdir -p $out/lib/ossl-modules
    ls -la lib
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
