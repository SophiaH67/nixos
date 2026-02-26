# Robotnix configurations

To build configs you need to build the flake output
`.#robotnixConfigurations.<host>.config.build.android`. For example, `nix build
.#robotnixConfigurations.yukihana-lamy.config.build.android`.

## Bootmask

To render the bootmask to a .png, open `bootmask.html` in chrome and set zoom to
75% (maybe because wayland 1.5x scaling? Idk). Capture node screenshot and check
that the files resolution is 448 x 605 (TODO:check if this actually matters..
Pentanes one is like that so I'll stick to it for now, I don't wish to wait
another 3 hours just to check rn).

## Yukihana Lamy

Stuff to set up after install;

- Steam Guard
- $BANK app
- Syncthing
