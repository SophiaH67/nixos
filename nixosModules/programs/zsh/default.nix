{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophrams.zsh.enable = lib.mkEnableOption "Soph Zsh";

  config = lib.mkIf config.sophrams.zsh.enable {
    programs.zsh.enable = true;

    users.users.sophia = {
      isNormalUser = true;
      description = "Sop";
      extraGroups = [
        "wheel"
        "dialout"
      ]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.programs.adb.enable "adbusers";
      initialPassword = "";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnikJ8VSNPM1pJQ2ylPLcyWGscM+9bFUnExJCTOjensY/yb2ONmacKlyAA6WX2LwiR24zYys8jS8SiACVo6YAC4LRaN6RwluHHS9gIF90d8lpydV9tn8NPm8N6+8K9HlYn9vguU1Yxpghcnh6KX+qfhBY3A09kRX2W0xIAu9+a7/rMCUWck7E0dfIOu1rn0r8/Jfp3M+VScpQBEv+E0Q9vT9EqqU+LgTWYt87EBNtim7FcX/9iQ3K1x6mNh5oOl7hWsRPnuEDsqLnx/MdWtng6JejzsXp/StGxdWqDVZhTYxLS8kBm92IeXEGynhQUjp8BdoRxRtoSFuoJaJxQVTAYdbnsjc+oge+5u8AlEuq2c3pObIEUZXp73+oMMhpujyfE91REAFpT1ltQJUxQh1YFuMFZhDNz02jy/c+32X/sJCKkRFKti0i/4REbfYiFPZ23QcPMgRRHAjZ4nhlrnyOCSK6vOFwrBUuIdyfVM33VUjk46riFvhxdVrOkv/dup4U= sophia@sophiah.gay"
      ];
      shell = pkgs.zsh;
    };

    age.secrets."atuin-key" = {
      file = ../../../secrets/atuin-key.age;
      mode = "600";
      owner = "sophia";
    };

    systemd.tmpfiles.rules = [
      "L /home/sophia/.local/share/atuin/key - - - - ${config.age.secrets."atuin-key".path}"
    ];

    home-manager.users.sophia =
      { pkgs, ... }:
      {
        
      };
  };
}
