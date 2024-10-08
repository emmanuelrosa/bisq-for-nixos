# The 2024 Bisq situation on NixOS

On the 7th of October 2024, OpenJDK 11 was removed from Nixpkgs on the master branch, due to it being end-of-life. See https://github.com/NixOS/nixpkgs/pull/347149

Bisq 1 depends on OpenJDK 11 and doesn't support any newer version, therefore from this point forward the `bisq-desktop` package in Nixpkgs will no longer build.

This Nix flake is a stop-gap solution to keep Bisq 1 alive on NixOS until Bisq 2 can replace it.

## Next steps

First, you should know that a Nix package for Bisq 2 is on the way (again). See https://github.com/NixOS/nixpkgs/pull/347160. However, in the mean time Bisq 1 is necessary because Bisq 2 has not yet reached feature-parity with Bisq 1.

The first thing I recommend is to get yourself a NixOS-friendly bundled version of Bisq 1. This can be your fallback once OpenJDK 11 gets removed from the NixOS build cache (Hydra). If you get this message soon enough, you can build a NixOS-friendly AppImage right from this Nix flake:

```
nix build github:emmanuelrosa/bisq-for-nixos#bisq-desktop-appimage
cp ./result ~/Bisq.AppImage
```

It's a heavy-weight at ~900 MB, but it's worth keeping it around. Go ahead and test it to make sure it works for you.

NOTE: The AppImage currently doesn't support HiDPI displays. I have plan for that, so stay tuned.

Once you have your fallback in place, you may choose to add `bisq-desktop` from this Nix flake instead of from Nixpkgs. Again, since this Nix flake pins Nixpkgs, I expect the package to build just fine until OpenJDK 11 is purged from the NixOS build cache. I have no idea when that may happen. After such an event you'd still be able to build Bisq 1, but you'd also have to build OpenJDK 11 and OpenJFX 11; That would take a while.

As a last resort, I uploaded a copy of the AppImage. You can get it from the releases.
