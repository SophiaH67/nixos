- Automate generating of boot keys with nixos rebuild so this config builds properly from scratch
    - Enrolling can be left out, but generating config only works when keys exist
- Set up renovate to update flake
- Set up CI to build all flakes to verify they're valid
- Set up CI to qemu-boot the flakes to verify they boot
- Potentially set up my own flake server?
- Start with helmfile
  