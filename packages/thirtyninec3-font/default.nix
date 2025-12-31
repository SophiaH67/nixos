{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "thirtyninec3-font";
  dontConfigue = true;
  src = pkgs.fetchzip {
    url = "https://events.ccc.de/congress/2025/infos/styleguide/39c3-styleguide-full-latest.zip";
    sha256 = "sha256-rMG8Km4EYJnC0MVaUXQsOiDGQt6Nhlj35UbUUorNH7E=";
  };
  installPhase = ''
    mkdir -p $out/share/fonts
    cp "$src/39C3-Fonts/Kario 39C3 Variable/Desktop/Kario39C3Var-Roman.ttf" $out/share/fonts
  '';
  meta = {
    description = "The 39C3 Font Family.";
  };
}
