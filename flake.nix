{
  description = "Bisq1 on life-support for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=6710d0dd013f55809648dfb1265b8f85447d30a6";
    nix-appimage.url = "github:ralismark/nix-appimage";
    nix-appimage.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-appimage }: {

    packages.x86_64-linux.bisq-desktop = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/bisq-desktop {
        makeBinPath = nixpkgs.legacyPackages.x86_64-linux.lib.makeBinPath;
        openjdk11 = nixpkgs.legacyPackages.x86_64-linux.openjdk11.override { enableJavaFX = true; };
    };

    packages.x86_64-linux.default = self.packages.x86_64-linux.bisq-desktop;
    packages.x86_64-linux.bisq-desktop-appimage = nix-appimage.bundlers.x86_64-linux.default self.packages.x86_64-linux.bisq-desktop;

  };
}
