{ lib, pkgs, config, ...}:
{
  home-manager.users.sophia.programs.git.signing.key = lib.mkForce "0AE2A6249EC695A8";
  home-manager.users.sophia.programs.git.userEmail = lib.mkForce "shage2@allegion.com";
  networking.hostName = lib.mkForce "asuna";
  services.displayManager.autoLogin.enable = lib.mkForce false;
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
