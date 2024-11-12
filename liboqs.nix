{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "liboqs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = pname;
    rev = version;
    sha256 = "sha256-+Gx1JPrJoeMix9DIF0rJQTivxN1lgaCIYFvJ1pnYZzM=";
  };

#  patches = [ ./fix-openssl-detection.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if enableStatic then "OFF" else "ON"}"
    "-DOQS_DIST_BUILD=ON"
    "-DOQS_BUILD_ONLY_LIB=ON"
  ];

  postInstall = ''
    echo fixing double slash
    if [ -f "$out/lib/pkgconfig/liboqs.pc" ]; then
      sed 's|//|/|g' $out/lib/pkgconfig/liboqs.pc > $out/lib/pkgconfig/liboqs.pc.tmp
      cp $out/lib/pkgconfig/liboqs.pc.tmp $out/lib/pkgconfig/liboqs.pc
    fi
  '';

#  dontFixCmake = true; # fix CMake file will give an error

  meta = with lib; {
    description = "C library for prototyping and experimenting with quantum-resistant cryptography";
    homepage = "https://openquantumsafe.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.sigmanificient ];
  };
}
