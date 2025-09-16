1. RAND_PASS=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)
2. nix run github:nix-community/nixos-anywhere -- --flake .#schwi --vm-test --disk-encryption-keys /tmp/disk-encryption.key "$RAND_PASS"
3. `echo "System rolled out, key: $RAND_PASS"
4. after reboot, `sudo systemd-cryptenroll --tpm2-pcrs=7 --tpm2-device=auto --unlock-key-file=/tmp/disk-encryption.key` 
