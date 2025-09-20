{
  users.groups.forgejo = {};
  users.users.forgejo = {
    isNormalUser = false;
    description = "Forgejo CI (for automatic deploys)";
    extraGroups = [
      "wheel"
    ];
    group = "forgejo";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxRWP14VnqsOH7ukPduWmotPLkkGzoEq4kr/URWQCoY root@244cfb52066d"
    ];
    isSystemUser = true;
  };
}