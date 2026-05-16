# bisq-for-nixos

This repository provides a Nix package to build an AppImage of Bisq v1.

# History

1. On the 7th of October 2024, OpenJDK 11 was removed from Nixpkgs on the master branch, due to it becoming end-of-life. See [https://github.com/NixOS/nixpkgs/pull/347149](https://github.com/NixOS/nixpkgs/pull/347149). Bisq 1 depended on OpenJFX 11 and didn't support any newer version, therefore I removed the Bisq 1 package from Nixpkgs and placed it in this repo, with the added ability to build an AppImage.
3. On the 29th of April 2025, I relocated the Bisq package in this repo to another Nix flake, which I created to provide various Bitcoin-related packages. The Nix package to build a Bisq AppImage remained in this repository.
2. On the 16th of May 2026, the Bisq team released version 1.10 in the wake of a security incident. That update included updating the JDK from 11 to 21, which at the time of this writing remains supported and is included in Nixpkgs.

## Packages

These are the packages contained in this Nix flake:

- *bisq-desktop*: This is an export of the bisq1 package from [btc-clients-nix](https://github.com/emmanuelrosa/btc-clients-nix).
- *bisq-desktop-appimage*: This is a Nix package which builds a NixOS-friendly AppImage out of *bisq-desktop*.
- *bisq-desktop-appimage-wrapper*: This is a wrapper which can be used to install the Bisq AppImage such that it integrates with NixOS like any other application. Meaning, with this package you can launch Bisq from your desktop's application menu.
- *bisq-desktop-appimage-entrypoint*: This is a wrapper which acts as the entry point for the Bisq AppImage. This makes it possible to use the AppImage with HiDPI displays by simply setting the environment variable `BISQ_HIDPI=1`.

## How to build the Bisq AppImage

Building the AppImage is easy:

```
nix build github:emmanuelrosa/bisq-for-nixos#bisq-desktop-appimage
cp ./result /path/to/my/Bisq.AppImage
```

The AppImage is quite large (approx. 1 GB) because it contains *all* of Bisq's dependencies.
