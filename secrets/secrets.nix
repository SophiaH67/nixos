let
  # Users
  soph-main = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnikJ8VSNPM1pJQ2ylPLcyWGscM+9bFUnExJCTOjensY/yb2ONmacKlyAA6WX2LwiR24zYys8jS8SiACVo6YAC4LRaN6RwluHHS9gIF90d8lpydV9tn8NPm8N6+8K9HlYn9vguU1Yxpghcnh6KX+qfhBY3A09kRX2W0xIAu9+a7/rMCUWck7E0dfIOu1rn0r8/Jfp3M+VScpQBEv+E0Q9vT9EqqU+LgTWYt87EBNtim7FcX/9iQ3K1x6mNh5oOl7hWsRPnuEDsqLnx/MdWtng6JejzsXp/StGxdWqDVZhTYxLS8kBm92IeXEGynhQUjp8BdoRxRtoSFuoJaJxQVTAYdbnsjc+oge+5u8AlEuq2c3pObIEUZXp73+oMMhpujyfE91REAFpT1ltQJUxQh1YFuMFZhDNz02jy/c+32X/sJCKkRFKti0i/4REbfYiFPZ23QcPMgRRHAjZ4nhlrnyOCSK6vOFwrBUuIdyfVM33VUjk46riFvhxdVrOkv/dup4U=";
  soph-work = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3kL6zYFM19TI987keNBlY8TLyPeRezGlT0ONrcl4ZmsRxQ/UCYyzJryo0mBTcTjTHoLT1W4h2zJ4fhBesJhaHvLp0+KmspTNLr72Bzn3csYNvtW8hjyXnv7DxreZxSrgsthwmzR56oykvlT13MKXCgzitcOxY0+bMykWaAH1ob8/z29MX/U1u3zMAG7IAH8qagJAwAX8n2AhHVFe5zmTAbIlv0s/P/OWHBBPTwASWX1MHJpXu2X9M3F6eJbIvYbzrkfW7c1EnwSDyixyrD4Ih4u+AJ4sHh3OLCW5CyD6vIiqHsEwe1AWZtpFAG/1JoRaNeJ8vNGJrr5evY3JrIeZse7TRDNvqwrKbgLyZWiQfMvoNsqhU0qQOMw0affPzbSFZUk4Grh5p9shbnXbGxY55ZdusEeyeuEGBA5TpOcabnqX5tYJeFoA2zRIEfJzQpjhknl9Wdnehkn/4BsXstGdOu5D2eYPU6OCLPNbT0gFL45brnLbtTmI7GgwmOXPKb0wQ32tuK5G6DCyJgnJK3UVJPsIGBRQ4XsvHMSbag/6jaYrB1K1WCEs38j2cGj9LfEiKBPAAhM60f9+uObwDYELkiejFuFYJaYEvxa9z9jD6sxkvOYt7ZS7x8xMbXvcFDXwWbpe0ZGCNJW3tbCGLjTzLoVsUfnygkfoo9cnPtjdnew==";
  forgejo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxRWP14VnqsOH7ukPduWmotPLkkGzoEq4kr/URWQCoY";
  haizakura = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9w0D3XABhwPAIfMYTjdMM1v3ZmoyUjspObDOQo2Ymw Haizakura";

  deviceKeys = import ./deviceKeys.nix;

  mococo-pocket-id = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfAtVhjXx8EeX/s4pHPGf5K87rSJ404g+fBhYrzVHAh pocket-id.mococo.dev.sophiah.gay";
  mococo-dn42 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN2lfZhC1IsCjw2nlSUM7Q1z9L6MP1rEDg4gMgI3UXQb dn42.mococo.dev.sophiah.gay";
  mococo-prometheus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVzNJFEV3vPHvYJqb2lOh4TWKvxsqT6K5skZFxQ5hBy prometheus.mococo.dev.sophiah.gay";

  # Groups
  developers = [
    deviceKeys.rikka
    soph-main
    deviceKeys.ayumu
  ];
  ex-machina = with deviceKeys; [
    schwi
    emir-eins
    emir-zwei
  ];
  servers = [ deviceKeys.mococo ] ++ ex-machina;
  users = [
    soph-main
    soph-work
    forgejo
  ];
  personal-devices = with deviceKeys; [
    rikka
    alice
    ayumu
  ];
  devices =
    servers
    ++ personal-devices
    ++ [
      deviceKeys.yuuna
      deviceKeys.kiara
    ];
  everyone = users ++ devices;
in
with deviceKeys;
{
  "secret1.age".publicKeys = everyone;
  "tailscale-device.age".publicKeys = devices;
  "soph-builder.id_ed25519.age".publicKeys = personal-devices;
  "atuin-key.age".publicKeys = personal-devices ++ [
    soph-main
    soph-work
  ];

  "renovate-haizakura.id_ed25519.age".publicKeys = [
    rikka
    soph-main
  ];
  "renovate-token.age".publicKeys = [
    rikka
    soph-main
  ];
  "renovate-gh-token.age".publicKeys = [
    rikka
    soph-main
  ];

  "skeb-scraper.env.age".publicKeys = developers ++ [ kiara ];

  # Pocket id
  "pocketid-encryptionkey.age".publicKeys = [ mococo-pocket-id ];
  "pocketid-maxmind.age".publicKeys = [ mococo-pocket-id ];
  "pocketid-smtppassword.age".publicKeys = [ mococo-pocket-id ];
  # Dn42
  "dn42-wgpriv.age".publicKeys = [ mococo-dn42 ];
  # Prometheus
  "prometheus-oath2keyfile.age".publicKeys = [ mococo-prometheus ];

  # Desktop things
  ## Pfp
  "face.png.age".publicKeys = devices;

  ## Wallpapers
  "wallpaper-fallback.png.age".publicKeys = devices;
  "wallpaper-rikka.png.age".publicKeys = developers ++ [ rikka ];
  "wallpaper-rikka-dark.png.age".publicKeys = developers ++ [ rikka ];
  "wallpaper-alice.png.age".publicKeys = developers ++ [ alice ];
  "wallpaper-alice-dark.png.age".publicKeys = developers ++ [ alice ];
  "wallpaper-ayumu.png.age".publicKeys = developers ++ [ ayumu ];
  "wallpaper-ayumu-dark.png.age".publicKeys = developers ++ [ ayumu ];

  # Isla
  "isla-rikka-wgpriv.age".publicKeys = [ rikka ];
  "isla-kiara-wgpriv.age".publicKeys = [ kiara ];
  "isla-mococo-wgpriv.age".publicKeys = [ mococo ];
  "isla-ayumu-wgpriv.age".publicKeys = [ ayumu ];
  "isla-schwi-wgpriv.age".publicKeys = [ schwi ];
  "isla-emir-eins-wgpriv.age".publicKeys = [ emir-eins ];
  "isla-emir-zwei-wgpriv.age".publicKeys = [ emir-zwei ];
}
