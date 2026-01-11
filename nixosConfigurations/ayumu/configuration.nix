{
  lib,
  pkgs,
  config,
  ...
}:
let
  orca-slicer = pkgs.symlinkJoin {
    name = "orca-slicer";
    paths = [ pkgs.orca-slicer ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/orca-slicer \
        --prefix LC_ALL : C \
        --prefix MESA_LOADER_DRIVER_OVERRIDE : zink \
        --prefix WEBKIT_DISABLE_DMABUF_RENDERER : 1 \
        --prefix __EGL_VENDOR_LIBRARY_FILENAMES : ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json \
        --prefix GALLIUM_DRIVER : zink
    '';
  };
in
{
  networking.hostName = "ayumu";
  networking.domain = "dev.sophiah.gay";

  environment.systemPackages = [
    pkgs.spotify
    orca-slicer
    pkgs.nvtopPackages.nvidia
  ];

  sophices.boot-unlock.enable = false;
  sophices.boot-unlock.tor = true;
  soph.drawing.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "sophia";

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  sophices.plymouth.enable = true;

  services.ollama.enable = false;
  services.ollama.package = pkgs.ollama-cuda;
  services.ollama.host = "[::]";
  services.nextjs-ollama-llm-ui.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  soph.dev.enable = true;
  soph.vr.enable = true;
}
