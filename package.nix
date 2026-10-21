{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, gtk4
, webkitgtk_6_0
, glib
, libsoup_3
}:

buildGoModule rec {
  pname = "magpie";
  version = "0.1.1307";

  src = fetchFromGitHub {
    owner = "yetone";
    repo = "magpie";
    rev = "v${version}";
    hash = "sha256-bP5q7heqypESgdfi+C46tJEYL6+x5YocKCrMP2CZs64=";
  };

  # The committed vendor/ is out of sync with go.mod; let Nix fetch modules instead.
  postUnpack = ''
    rm -rf source/vendor
  '';
  proxyVendor = true;
  vendorHash = "sha256-+KLmkyVHohSlLsOKEmnn8zknCLDPaCrHSg7N5CS4rrk=";

  # Only the app itself; the repo's other main packages (e.g. genpurposes) are dev tools.
  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];
  buildInputs = [ gtk4 webkitgtk_6_0 glib libsoup_3 ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  # Upstream tests need network access and a display.
  doCheck = false;

  meta = {
    description = "Model and provider manager for AI coding agents";
    homepage = "https://github.com/yetone/magpie";
    changelog = "https://github.com/yetone/magpie/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "magpie";
  };
}
