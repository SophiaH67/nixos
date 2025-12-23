{ lib, ... }:
{
  soph.base.enable = true;

  # https://grahamc.com/blog/erase-your-darlings/
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r Fuwawa/local/root@blank
  '';

  networking.hostName = "mococo";
  networking.domain = "dev.sophiah.gay";

  home-manager.users.sophia = {
    sophrams.atuin.enable = lib.mkForce false;
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  sophices.boot-unlock.enable = true;

  services.openssh.hostKeys = [
    {
      path = "/persist/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/persist/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];
}
