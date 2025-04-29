# Update

The Bisq 1 package has been moved to https://github.com/emmanuelrosa/btc-clients-nix

If you wish to install the Bisq 1 package, I recommend using that repo instead. However, if you wish to build an AppImage from the package, then this repo is for you.

# The 2024 Bisq situation on NixOS

On the 7th of October 2024, OpenJDK 11 was removed from Nixpkgs on the master branch, due to it being end-of-life. See https://github.com/NixOS/nixpkgs/pull/347149

Bisq 1 depends on OpenJFX 11 and doesn't support any newer version, therefore from this point forward the `bisq-desktop` package in Nixpkgs will no longer build.

This Nix flake is a stop-gap solution to keep Bisq 1 alive on NixOS until Bisq 2 can replace it.

## Packages

These are the packages contained in this Nix flake:

- *bisq-desktop*: This is a copy of the bisq-desktop package from Nixpkgs, but with a few fixes to make it work as an AppImage.
- *bisq-desktop-appimage*: This is a Nix package which builds a NixOS-friendly AppImage out of bisq-desktop.
- *bisq-desktop-appimage-wrapper*: This is a wrapper which can be used to install the Bisq AppImage such that it integrates with NixOS like any other application. Meaning, with this package you can launch Bisq from your desktop's application menu.
- *bisq-desktop-appimage-entrypoint*: This is a wrapper which acts as the entry point for the Bisq AppImage. This makes it possible to use the AppImage with HiDPI displays by simply setting the environment variable `BISQ_HIDPI=1`.

## Next steps

First, you should know that a Nix package for Bisq 2 is now in Nixpkgs. However, in the mean time Bisq 1 is necessary because Bisq 2 has not yet reached feature-parity with Bisq 1.

The first thing I recommend is to get yourself a NixOS-friendly bundled version of Bisq 1.

```
nix build github:emmanuelrosa/bisq-for-nixos#bisq-desktop-appimage
cp ./result /path/to/my/Bisq.AppImage
```

Hopefully, you'll be able to build that without having to build OpenJDK 11 too.

It's a heavy-weight at ~900 MB because it contains *all* of Bisq's dependencies. Go ahead and test it to make sure it works for you.

Once you have an AppImage as a fallback, you have a number of options:

- Use the `bisq-desktop` package in this repo: This is a drop-in replacement for the same package in Nixpkgs. The difference is that this one is pinned to a Nixpkgs version which still has OpenJDK 11.
- Use the AppImage directly: You can go ahead and use it in place of the `bisq-desktop` package.
- Use the AppImage wrapper package: For a more Nixified experience, use the `bisq-desktop-appimage-wrapper` package with your AppImage to make it installable as an ordinary Nix package:

```
environment.systemPackages = [
  (bisq-for-nixos.packages.x86_64-linux.bisq-desktop-appimage-wrapper.override {
    bisqAppImage = "/path/to/my/Bisq.AppImage";
  });
  ...
];
```

With that in place, you don't have to worry about OpenJDK 11 getting booted out of the NixOS build cache.
