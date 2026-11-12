{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksh93";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "ksh93";
    repo = "ksh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hrXW+PKQ6v0CCKiZ8E3HAEcrt9m4ZO5QfwFT9rCgbxc=";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    bin/package make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    bin/package install "$out"
    runHook postInstall
  '';

  meta = {
    description = "Maintained KornShell 93u+m";
    homepage = "https://github.com/ksh93/ksh";
    license = lib.licenses.epl10;
    platforms = lib.platforms.unix;
    mainProgram = "ksh";
  };
})
