{ pkgs, ... }@args:
let
  s_calibration = pkgs.writeShellScriptBin "calibration" ''
    ${pkgs.motoc}/bin/motoc continue
    echo "\n---\nExited with code: $?\n---\n"
    read -p "Press enter to exit"
  '';
  s_overlay = pkgs.writeShellScriptBin "overlay" ''
    ${pkgs.wlx-overlay-s}/bin/wlx-overlay-s --replace
    echo "\n---\nExited with code: $?\n---\n"
    read -p "Press enter to exit"
  '';
  s_vrcft = pkgs.writeShellScriptBin "vrcft" ''
    /home/sophia/git/VRCFaceTracking.Avalonia/result/bin/vrchatfacetracking
    echo "\n---\nExited with code: $?\n---\n"
    read -p "Press enter to exit"
  '';
  s_lh = pkgs.writeShellScriptBin "lh" ''
    ${pkgs.lighthouse-steamvr}/bin/lighthouse --state on --bsid hci0/dev_FE_02_B9_4A_08_B6
    ${pkgs.lighthouse-steamvr}/bin/lighthouse --state on --bsid hci0/dev_DB_3A_5D_C8_91_B6
    ${pkgs.lighthouse-steamvr}/bin/lighthouse --state on --bsid hci0/dev_C1_18_FC_FB_6A_46
    echo "\n---\nExited with code: $?\n---\n"
    read -p "Press enter to exit"
  ''; 

  c_runInKitty = pkgs.writeShellScriptBin "runInKitty" ''
    echo Launching services...
    echo $(date) > /home/sophia/.vr-lastran
    sleep 0.1
    ${pkgs.kitty}/bin/kitty @ launch --type=tab --title VR-LH -- ${s_lh}/bin/lh
    sleep 0.1
    ${pkgs.kitty}/bin/kitty @ launch --type=tab --title VR-Calibration -- ${s_calibration}/bin/calibration
    sleep 0.1
    ${pkgs.kitty}/bin/kitty @ launch --type=tab --title VR-Overlay -- ${s_overlay}/bin/overlay
    sleep 0.1
    ${pkgs.kitty}/bin/kitty @ launch --type=tab --title VR-FaceTracking -- ${s_vrcft}/bin/vrcft
    sleep 0.1
    echo "Done!"
    read -p "Press enter to exit"
  '';
in
  pkgs.stdenv.mkDerivation {
    pname = "soph-vr-mode";
    version = "0.1.0";

    src = pkgs.writeShellScriptBin "soph-vr-mode" "${pkgs.kitty}/bin/kitty ${c_runInKitty}/bin/runInKitty";
    
    dontUnpack = true;

    runtimeDependencies = with pkgs; [ bash kitty lighthouse-steamvr motoc wlx-overlay-s c_runInKitty s_calibration s_overlay s_lh ];

    installPhase = ''
      install -D $src/bin/soph-vr-mode $out/bin/soph-vr-mode
    '';

    nativeBuildInputs = with pkgs; [
      makeWrapper
      copyDesktopItems
    ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "soph-vr-mode";
        desktopName = "Soph Vr Mode";
        comment = "Spawn all VR tools in one easy script";
        exec = "soph-vr-mode";
        terminal = false;
        categories = [
          "Utility"
        ];
      })
    ];
  }