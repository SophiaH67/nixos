{ pkgs, ... }:

# A derivation that converts all WAVs in ./sounds to Asterisk-safe WAVs
let
  asteriskSounds = pkgs.stdenv.mkDerivation {
    name = "asterisk-custom-sounds";
    src = ./sounds;

    buildInputs = [ pkgs.sox ];

    installPhase = ''
      mkdir -p $out
      for f in $src/*.wav; do
        base=$(basename "$f" .wav)
        # Convert to 8kHz mono 16-bit PCM WAV
        sox "$f" -r 8000 -c 1 -b 16 "$out/$base.wav"
      done
    '';
  };
in
{
  environment.etc."asterisk/sounds/custom".source = asteriskSounds;
}
