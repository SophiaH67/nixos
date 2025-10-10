{ lib, pkgs, config, ...}:
{
  imports = [ ../rikka/configuration.nix ];

  home-manager.users.sophia.programs.git.signing.key = lib.mkForce "0AE2A6249EC695A8";
  home-manager.users.sophia.programs.git.userEmail = lib.mkForce "shage2@allegion.com";
  networking.hostName = lib.mkForce "asuna";
  home-manager.users.sophia.programs.git.extraConfig = {
    url = {
      "git@ssh.dev.azure.com:v3/ircost/SV_FW_Drivers/SV_FW_Drivers" = {
        insteadOf = "https://ircost@dev.azure.com/ircost/SV_FW_Drivers/_git/SV_FW_Drivers";
      };
      "git@ssh.dev.azure.com:v3/ircost/SV_FW_Drivers/DriverWrapper" = {
        insteadOf = "https://ircost@dev.azure.com/ircost/SV_FW_Drivers/_git/DriverWrapper";
      };
    };
  };
  environment.systemPackages = with pkgs; [ teams-for-linux cmake libgcc gnumake eddie btop cavalier ];

  users.users.sophia.extraGroups = [ "dialout" ];

  # For simonsvoss smartstick AX
  boot.kernelModules = [ "ftdi_sio" ];
  # For building aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  age.secrets.secret1.file = ../../secrets/secret1.age;
  environment.etc."secret1".source = config.age.secrets.secret1.path;
  environment.etc."secret1.src".text = config.age.secrets.secret1.path;
  age.identityPaths = [ "/home/sophia/.ssh/id_rsa" ];
}
