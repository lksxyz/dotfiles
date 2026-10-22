{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "omp";
  version = "18.12.6";

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-x64";
    sha256 = "sha256-hdna86Bfx26M1CWuGQTrV2r40hzIX89GkHQmJuB8z6Q=";
  };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/omp
    runHook postInstall
  '';

  meta = {
    description = "Coding agent CLI (Oh My Pi)";
    homepage = "https://omp.sh";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = [ "x86_64-linux" ];
  };
}
