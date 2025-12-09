{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophices.syncthing.enable = lib.mkEnableOption "Soph Syncthing";

  config = lib.mkIf config.sophices.syncthing.enable {
    services.syncthing = {
      enable = true;
      overrideDevices = false;
      overrideFolders = false;
      guiAddress = "[::1]:8384";
      settings = {
        devices = {
          mococo = {
            id = "6IPUJU4-PX3VFSP-EZ3PNAU-7CVOXAG-476QTZB-4DEORJB-NB4B2XQ-WF72BAN";
          };
          rikka = {
            id = "H57XCEM-AE6HEL7-AOXSSIY-4JDLLCD-PZTAQFB-QQZBX2C-7UQVDM6-5QBAVAM";
          };
          ayumu = {
            id = "3WOL2NN-YEMHJEJ-KQ3NWIZ-2ZVEK6S-N3ADXL3-VNPJCKB-3ZLFBEY-FIFYQQX";
          };
          tyrants_eye = {
            id = "A3QLL5C-ARZUF27-VKUT5OY-6ZAVJS4-55VGXZ6-EGKH2AB-OVQZSUU-GCXGVQX";
          };
          alice = {
            id = "RXLKWVK-WRPWLP7-7ECMV7D-OJTTV6A-OTTDSX7-FFPLH7N-FDQLNBQ-FNUPGAV";
          };
        };
        folders = {
          "/home/sophia/sync" = {
            id = "nei9h-knicz";
            devices = [
              "alice"
              "mococo"
              "ayumu"
              "rikka"
            ];
            label = "Soph's Nix Syncing";
          };
        };
      };
    };
  };
}
