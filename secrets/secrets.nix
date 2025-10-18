let
  # Users
  soph-main = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnikJ8VSNPM1pJQ2ylPLcyWGscM+9bFUnExJCTOjensY/yb2ONmacKlyAA6WX2LwiR24zYys8jS8SiACVo6YAC4LRaN6RwluHHS9gIF90d8lpydV9tn8NPm8N6+8K9HlYn9vguU1Yxpghcnh6KX+qfhBY3A09kRX2W0xIAu9+a7/rMCUWck7E0dfIOu1rn0r8/Jfp3M+VScpQBEv+E0Q9vT9EqqU+LgTWYt87EBNtim7FcX/9iQ3K1x6mNh5oOl7hWsRPnuEDsqLnx/MdWtng6JejzsXp/StGxdWqDVZhTYxLS8kBm92IeXEGynhQUjp8BdoRxRtoSFuoJaJxQVTAYdbnsjc+oge+5u8AlEuq2c3pObIEUZXp73+oMMhpujyfE91REAFpT1ltQJUxQh1YFuMFZhDNz02jy/c+32X/sJCKkRFKti0i/4REbfYiFPZ23QcPMgRRHAjZ4nhlrnyOCSK6vOFwrBUuIdyfVM33VUjk46riFvhxdVrOkv/dup4U=";
  soph-work = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3kL6zYFM19TI987keNBlY8TLyPeRezGlT0ONrcl4ZmsRxQ/UCYyzJryo0mBTcTjTHoLT1W4h2zJ4fhBesJhaHvLp0+KmspTNLr72Bzn3csYNvtW8hjyXnv7DxreZxSrgsthwmzR56oykvlT13MKXCgzitcOxY0+bMykWaAH1ob8/z29MX/U1u3zMAG7IAH8qagJAwAX8n2AhHVFe5zmTAbIlv0s/P/OWHBBPTwASWX1MHJpXu2X9M3F6eJbIvYbzrkfW7c1EnwSDyixyrD4Ih4u+AJ4sHh3OLCW5CyD6vIiqHsEwe1AWZtpFAG/1JoRaNeJ8vNGJrr5evY3JrIeZse7TRDNvqwrKbgLyZWiQfMvoNsqhU0qQOMw0affPzbSFZUk4Grh5p9shbnXbGxY55ZdusEeyeuEGBA5TpOcabnqX5tYJeFoA2zRIEfJzQpjhknl9Wdnehkn/4BsXstGdOu5D2eYPU6OCLPNbT0gFL45brnLbtTmI7GgwmOXPKb0wQ32tuK5G6DCyJgnJK3UVJPsIGBRQ4XsvHMSbag/6jaYrB1K1WCEs38j2cGj9LfEiKBPAAhM60f9+uObwDYELkiejFuFYJaYEvxa9z9jD6sxkvOYt7ZS7x8xMbXvcFDXwWbpe0ZGCNJW3tbCGLjTzLoVsUfnygkfoo9cnPtjdnew==";
  forgejo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxRWP14VnqsOH7ukPduWmotPLkkGzoEq4kr/URWQCoY";

  # Device host keys
  rikka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFOHVN3nsJvlslN8PfU7A3ebu0+XA7Djuqrbgw6dP0t/";
  alice = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbmPJPqKuHQoPzT6+K5gKDP/xU0fqg70tcY2cvzjC30";
  yuuna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEsn1taHd1G7MLs5uI4tYsWgpYRA+d6/MdDhGtcOiGEt";

  schwi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPHtJcY8q0xm/J8AkGbX+kx91zXpo8H893mUGqJblgh";
  emir-eins = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPSscREH9OS6V6uDUgtcnELGBcjTZsqJfsmdu28Q/+C";
  emir-zwei = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdm/2geT7+PxYUSQeiOLGpchxaihM5Bxu88QKLZVoZT";

  # Groups
  developers = [ rikka soph-main ];
  ex-machina = [ schwi emir-eins emir-zwei ];
  users = [ soph-main soph-work forgejo ];
  personal-devices = [ rikka alice ];
  devices = ex-machina ++ personal-devices ++ [ yuuna ];
  everyone = users ++ devices;
in
{
  "secret1.age".publicKeys = everyone;
  "tailscale-device.age".publicKeys = devices;
  # Kube Things
  "kube-longhorn.age".publicKeys = developers ++ ex-machina;
  "kube-join-key.age".publicKeys = developers ++ ex-machina;
  "kube-forgejo-registration-secret.age".publicKeys = developers ++ ex-machina;

  # Desktop things
  ## Pfp
  "face.png.age".publicKeys = devices;

  ## Wallpapers
  "wallpaper-fallback.png.age".publicKeys = devices;
  "wallpaper-rikka.png.age".publicKeys = developers ++ [ rikka ];
  "wallpaper-rikka-dark.png.age".publicKeys = developers ++ [ rikka ];
  "wallpaper-alice.png.age".publicKeys = developers ++ [ alice ];
  "wallpaper-alice-dark.png.age".publicKeys = developers ++ [ alice ];
}