{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "omp";
  version = "18.10.4";

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-x64";
    sha256 = "sha256-/1n8G0hMEwinJHrSCDBQBWJ7P6xitEBzfCsYNawyB04=";
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
