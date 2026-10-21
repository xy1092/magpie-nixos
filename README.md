# magpie-nixos

Unofficial Nix flake packaging [magpie](https://github.com/yetone/magpie), a model and provider manager for AI coding agents by [yetone](https://github.com/yetone).

This repository only contains the packaging. All credit for magpie goes to its upstream authors. For bugs in magpie itself, report them [upstream](https://github.com/yetone/magpie/issues). For packaging problems, open an issue here.

Packaged version: `0.1.1307` (Linux, x86_64 and aarch64).

## Try it

```bash
nix run github:xy1092/magpie-nixos
```

## Use in a NixOS flake

```nix
{
  inputs.magpie-nixos.url = "github:xy1092/magpie-nixos";

  outputs = { nixpkgs, magpie-nixos, ... }: {
    nixosConfigurations.<host> = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.overlays = [ magpie-nixos.overlays.default ]; }
        ({ pkgs, ... }: { environment.systemPackages = [ pkgs.magpie ]; })
      ];
    };
  };
}
```

The overlay builds magpie against your own nixpkgs. To use this flake's pinned nixpkgs instead, add `magpie-nixos.packages.x86_64-linux.magpie` directly.

## Notes

- The GUI is built with Wails v3 on GTK4 and WebKitGTK 6.0. `magpie tui` and `magpie web` don't need a desktop.
- If GTK4 prints `Can't connect to a11y bus`, your session is missing the AT-SPI bus. On NixOS, set `services.gnome.at-spi2-core.enable = true;`.
- Upstream commits a `vendor/` directory that is out of sync with `go.mod`. The package deletes it and lets Nix fetch the Go modules itself.

## Updating

Bump `version` in `package.nix`, then set `hash` and `vendorHash` to `lib.fakeHash` one at a time and rebuild. Each build failure prints the correct hash to paste in.

## License

The packaging files in this repository are MIT licensed. magpie itself is [MIT licensed](https://github.com/yetone/magpie/blob/main/LICENSE) by yetone.
