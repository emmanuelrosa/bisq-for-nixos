{ stdenvNoCC
, lib
, fetchurl
, makeDesktopItem
, copyDesktopItems
, imagemagick
, writeScript
, bash
, bisqAppImage
}:

let
  launcher = enableHiDPI: writeScript "launcher" ''
    #! ${bash}/bin/bash

    ${lib.optionalString enableHiDPI "export BISQ_HIDPI=1"}
    exec @bisqAppImage@
  '';
in
stdenvNoCC.mkDerivation rec {
  pname = "bisq-desktop-appimage-wrapper";
  version = "1.0.0";
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Bisq";
      exec = "bisq-desktop";
      icon = "bisq";
      desktopName = "Bisq ${version}";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
    })

    (makeDesktopItem {
      name = "Bisq-hidpi";
      exec = "bisq-desktop-hidpi";
      icon = "bisq";
      desktopName = "Bisq ${version} (HiDPI)";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin

    install -D -m 777 ${launcher false} $out/bin/bisq-desktop
    substituteInPlace $out/bin/bisq-desktop --subst-var-by bisqAppImage ${bisqAppImage}

    install -D -m 777 ${launcher true} $out/bin/bisq-desktop-hidpi
    substituteInPlace $out/bin/bisq-desktop-hidpi --subst-var-by bisqAppImage ${bisqAppImage}

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      convert $src/bisq.png -resize $size bisq.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq.png
    done;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Decentralized bitcoin exchange network";
    longDescription = "A Nix wrapper for the bisq-desktop AppImage. It makes the Bisq AppImage appear as a normal Nix package, launchable from the desktop environment's application menu. Build an AppImage and then wrap it with this package by overriding the `bisqAppImage` attribute.";
    homepage = "https://bisq.network";
    license = licenses.mit;
    maintainers = with maintainers; [ emmanuelrosa ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "bisq-desktop";
  };
}
