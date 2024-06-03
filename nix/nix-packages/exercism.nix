{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
, autoPatchelfHook ? pkgs.autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "exercism";
  version = "3.2.0";

  src = fetchurl {
    url = "https://github.com/exercism/cli/releases/download/v3.2.0/exercism-3.2.0-linux-x86_64.tar.gz";
    sha256 = "sha256-TqPh6okWqAA9qV29bu96OimALmN+1qDyqqovHJh1SRU=";
  };

  # nativeBuildInputs = [
    # autoPatchelfHook
  # ];

  buildInputs = [
    stdenv.cc.cc
  ];

  sourceRoot = "./";

  installPhase = ''
    ls -1
    install -m755 -D exercism $out/bin/exercism
  '';

  meta = with lib; {
    homepage = "https://exercism.org";
    description = "exercism CLI";
    platforms = platforms.linux;
    architectures = [ "amd64" ];
  };
}

