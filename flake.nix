{
  description = "Bisq1 on life-support for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=6710d0dd013f55809648dfb1265b8f85447d30a6";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.bisq-desktop = nixpkgs.legacyPackages.x86_64-linux.bisq-desktop;
    packages.x86_64-linux.default = self.packages.x86_64-linux.bisq-desktop;

  };
}
