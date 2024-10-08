{
  description = "Bisq1 on life-support for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=6710d0dd013f55809648dfb1265b8f85447d30a6";
    nix-appimage.url = "github:ralismark/nix-appimage";
    nix-appimage.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-appimage }: {

    packages.x86_64-linux = let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      bisq-desktop = pkgs.callPackage ./pkgs/bisq-desktop {
        makeBinPath = pkgs.lib.makeBinPath;
        openjdk11 = pkgs.openjdk11.override { enableJavaFX = true; };
      };

      bisq-desktop-appimage-entrypoint = pkgs.callPackage ./pkgs/bisq-desktop-appimage-entrypoint {
        bisq-desktop = self.packages."${system}".bisq-desktop;
      };

      bisq-desktop-appimage = nix-appimage.bundlers."${system}".default self.packages."${system}".bisq-desktop-appimage-entrypoint;

      bisq-desktop-appimage-wrapper = pkgs.callPackage ./pkgs/bisq-desktop-appimage-wrapper {
        bisqAppImage = self.packages."${system}".bisq-desktop-appimage;
      };

      default = self.packages."${system}".bisq-desktop;
    };

  };
}
