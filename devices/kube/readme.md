1. export RAND_PASS=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)
2. nix run github:nix-community/nixos-anywhere -- --flake .#schwi --vm-test --disk-encryption-keys /tmp/disk-encryption.key "$RAND_PASS"
3. after reboot, systemd-cryptenroll --tpm2-device=auto