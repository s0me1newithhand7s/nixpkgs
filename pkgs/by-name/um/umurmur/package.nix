{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
  protobufc,
  libconfig,
}:

stdenv.mkDerivation rec {
  pname = "umurmur";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "umurmur";
    repo = "umurmur";
    rev = version;
    sha256 = "sha256-q5k1Lv+/Kz602QFcdb/FoWWaH9peAQIf7u1NTCWKTBM=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    openssl
    protobufc
    libconfig
  ];

  # https://github.com/umurmur/umurmur/issues/176
  postPatch = ''
    sed -i '/CRYPTO_mem_ctrl(CRYPTO_MEM_CHECK_ON);/d' src/ssli_openssl.c
  '';

  configureFlags = [
    "--with-ssl=openssl"
    "--enable-shmapi"
  ];

  meta = with lib; {
    description = "Minimalistic Murmur (Mumble server)";
    license = licenses.bsd3;
    homepage = "https://github.com/umurmur/umurmur";
    platforms = platforms.all;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    mainProgram = "umurmurd";
  };
}
