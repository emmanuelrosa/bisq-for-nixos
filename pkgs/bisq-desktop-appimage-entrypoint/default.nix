{ stdenvNoCC
, lib
, bisq-desktop
, writeScript
, bash
}:

let
  entrypoint = writeScript "bisq-desktop-appimage-entrypoint" ''
    #! ${bash}/bin/bash

    BISQ_HIDPI=''${BISQ_HIDPI:-0}

    if [ $BISQ_HIDPI -eq 1 ]
    then
      exec @src@/bin/bisq-desktop-hidpi "$@"
    else
      exec @src@/bin/bisq-desktop "$@"
    fi
  '';
in
stdenvNoCC.mkDerivation rec {
  pname = "bisq-desktop-appimage-entrypoint";
  version = bisq-desktop.version;
  src = bisq-desktop;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin
    install -D -m 777 ${entrypoint} $out/bin/entrypoint
    substituteAllInPlace $out/bin/entrypoint

    runHook postInstall
  '';

  meta = with lib; {
    description = "Decentralized bitcoin exchange network";
    longDescription = "This package provides a script which can be used by an AppImage to launch Bisq. This is needed to be able to launch Bisq in HiDPI mode without having to create a 2nd AppImage. To choose HiDPI mode, set the environment variable BISQ_HIDPI=1";
    homepage = "https://bisq.network";
    license = licenses.mit;
    maintainers = with maintainers; [ emmanuelrosa ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "entrypoint";
  };
}
