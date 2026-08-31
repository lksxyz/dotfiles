{
  stdenvNoCC,
  fetchurl,
  lib,
}:

# Official prebuilt Agave release (same binaries the docs' "Download Prebuilt
# Binaries" path provides). Why not nixpkgs' `solana-cli`: at the pinned
# nixpkgs revision the 3.0.12 source build fails under the pinned rustc
# (`unused-unsafe` denied by `-D warnings`), and it compiles ~15 binaries
# for tens of minutes. When nixpkgs fixes the package, revert to
# `solana-cli` in modules/blockchain.nix.
stdenvNoCC.mkDerivation rec {
  pname = "solana-cli";
  version = "3.0.12";

  src = fetchurl {
    url = "https://github.com/anza-xyz/agave/releases/download/v${version}/solana-release-x86_64-unknown-linux-gnu.tar.bz2";
    sha256 = "sha256-c6lzRkgcqROv6DDY4ix1fR6vVBYC5d686q4i3nciKtU=";
  };

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    # Keep the release layout intact: cargo-build-sbf locates
    # platform-tools-sdk/deps next to its own binary.
    tar xjf $src -C $out
    runHook postInstall
  '';

  meta = {
    description = "Solana/Agave CLI and SBF toolchain (official prebuilt release)";
    homepage = "https://github.com/anza-xyz/agave";
    license = lib.licenses.asl20;
    mainProgram = "solana";
    platforms = [ "x86_64-linux" ];
  };
}
