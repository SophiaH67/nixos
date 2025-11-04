## Initial Deploy

1. `export RAND_PASS=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)`
2. `nix run github:nix-community/nixos-anywhere -- --flake .#schwi --disk-encryption-keys /tmp/disk-encryption.key <(echo -n "$RAND_PASS") root@192.168.178.126`
3. `echo "System rolled out, after reboot, enter key manually once: $RAND_PASS"`

## Future Deploy

1.nix run github:serokell/deploy-rs .#schwi

## Test

1. nix run .#nixosConfigurations.schwi.config.system.build.vmWithDisko