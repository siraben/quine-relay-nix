{
  lib,
  stdenv,
  fetchgit,
  ncurses,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "afnix";
  version = "3.8.0";

  src = fetchgit {
    url = "https://salsa.debian.org/debian/afnix.git";
    rev = "62dc58f04effb13c6727f0f620b1c3b5627e9007";
    hash = "sha256-54tNrO2pTunaZJJ2f0XICxvMGcP6YPv9Gd/4kLMJnO8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ncurses ];

  postPatch = ''
    # Apply Debian patches (skip 0002-allRpath which hardcodes /usr/lib/afnix)
    for p in debian/patches/0*.patch debian/patches/Use-dpkg-buildflags-for-gcc-12.patch; do
      case "$p" in
        *0002-allRpath*) echo "Skipping $p (impure paths)" ;;
        *) echo "Applying $p"; patch -p1 < "$p" ;;
      esac
    done

    # Fix hardcoded paths
    find . -type f -exec sed -i 's|/bin/mkdir|mkdir|g' {} +
    find . -type f -exec sed -i 's|/bin/rm|rm|g' {} +
    find . -type f -exec sed -i 's|/bin/cp|cp|g' {} +
    find . -type f -exec sed -i 's|/bin/ln|ln|g' {} +
    find . -type f -exec sed -i 's|/bin/mv|mv|g' {} +
    find . -type f -exec sed -i 's|/bin/echo|echo|g' {} +
  '';

  buildPhase = ''
    runHook preBuild
    mkdir -p bld/cnf
    # Fix missing termios.h include
    sed -i '1i #include <termios.h>' src/lib/plt/shl/ctrm.cxx 2>/dev/null || true
    # Fix impure rpath and dpkg-buildflags references
    find cnf/mak -name '*.mak' -exec sed -i "s|-rpath=/usr/lib/afnix|-rpath=$out/lib/afnix|g" {} +
    find cnf/mak -name '*.mak' -exec sed -i "s|-rpath-link,/usr/lib/afnix|-rpath-link,$out/lib/afnix|g" {} +
    find cnf/mak -name '*.mak' -exec sed -i 's|`dpkg-buildflags[^`]*`||g' {} +
    find cnf/mak -name '*.mak' -exec sed -i 's|\$(shell dpkg-buildflags[^)]*)||g' {} +
    # Disable -Werror (GCC 15 has new warnings)
    find cnf/mak -name '*.mak' -exec sed -i 's/-Werror//g' {} +
    ./cnf/bin/afnix-setup -o --prefix $out
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install
    # Wrap axi so it can find afnix modules at runtime
    wrapProgram $out/bin/axi \
      --prefix LD_LIBRARY_PATH : "$out/lib"
    runHook postInstall
  '';

  meta = {
    description = "AFNIX - a multi-threaded functional programming language";
    homepage = "http://www.afnix.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "axi";
  };
}
