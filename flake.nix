{
  description = "Unofficial Nix package for magpie (github.com/yetone/magpie)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        magpie = pkgs.callPackage ./package.nix { };
        default = magpie;
      });

      overlays.default = final: prev: {
        magpie = final.callPackage ./package.nix { };
      };
    };
}
