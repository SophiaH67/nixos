{
  config,
  lib,
  pkgs,
  nixos-config,
  ...
}:
{
  options.sophrams.vscode.enable = lib.mkEnableOption "Soph VSCode";

  config = lib.mkIf config.sophrams.vscode.enable {
    home.packages = with pkgs; [ markdownlint-cli2 ];

    programs.vscode = {
      enable = true;
      # https://www.reddit.com/r/NixOS/comments/15mohek/installing_vscode_extensions_with_homemanager_not/
      mutableExtensionsDir = false;
      # https://github.com/continuedev/continue/issues/821#issuecomment-3227673526
      package = (
        pkgs.vscode.overrideAttrs (
          final: prev: {
            preFixup =
              prev.preFixup
              + "gappsWrapperArgs+=( --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.gcc.cc.lib ]} )"
              + (
                if (nixos-config.hardware.nvidia.enabled) then
                  "\nwrapProgram $out/bin/code --add-flags --ozone-platform=x11"
                else
                  ""
              );
          }
        )
      );
      profiles.default = {
        userSettings = {
          git.confirmSync = false;
          git.enableSmartCommit = true;
          git.autofetch = true;
          git.replaceTagsWhenPull = true;
          git.autoStash = true;
          editor.cursorSmoothCaretAnimation = "on";
          files.autoSave = "afterDelay";
          terminal.integrated.enableMultiLinePasteWarning = false;
          prohe.serverAddress = "ws://192.168.67.26:12345";
          prohe.typingWindow = 10000;
          prohe.vibrationMax = 1;
          workbench.iconTheme = "material-icon-theme";
          workbench.editor.wrapTabs = true;
          window.autoDetectColorScheme = true;
          workbench.colorTheme = "98878c8e-9f91-4e25-930d-dd7d280d9e35";
          workbench.preferredDarkColorTheme = "5412c41d-f76b-4488-85a7-1ae1a63bbfcc";
          editor.fontFamily = "'Cascadia Code',Consolas, 'Courier New', monospace";
          terminal.integrated.stickyScroll.enabled = false;
          chat.disableAIFeatures = true;
          nix.enableLanguageServer = true;
          nix.serverPath = "${pkgs.nixd}/bin/nixd";
          editor.rulers = [
            80
          ];
        };
        extensions =
          with pkgs.vscode-extensions;
          [
            yzhang.markdown-all-in-one
            github.vscode-pull-request-github
            github.vscode-github-actions
            ms-vscode-remote.remote-ssh
            yoavbls.pretty-ts-errors
            prisma.prisma
            pkief.material-icon-theme
            esbenp.prettier-vscode
            eamodio.gitlens
            leonardssh.vscord
            stkb.rewrap
            jnoortheen.nix-ide
            llvm-vs-code-extensions.vscode-clangd
            llvm-vs-code-extensions.lldb-dap
            ms-dotnettools.csdevkit
            ms-dotnettools.csharp
            ms-vscode.cmake-tools
            ms-dotnettools.vscode-dotnet-runtime
            mkhl.direnv
            ms-vscode.hexeditor
            continue.continue
            wakatime.vscode-wakatime
            ms-python.black-formatter
            bradlc.vscode-tailwindcss
            ms-python.python
            davidanson.vscode-markdownlint
            rust-lang.rust-analyzer
            golang.go
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "prohe";
              publisher = "UncensorPat";
              version = "0.1.0";
              sha256 = "mq4SP+FM3rMOYf9e6lmPcxQQn2CpgN95L3J6mXlHY1s=";
            }
            {
              name = "doki-theme";
              publisher = "unthrottled";
              version = "88.1.18";
              sha256 = "7Ditwj7U26t3v4ofpqw/sHar6uE46E4DWVwGZjziZfM=";
            }
            {
              name = "emoji";
              publisher = "perkovec";
              version = "1.0.1";
              sha256 = "vHKmXbeXKRyVqLuhvFagv9Q1WdHNL7a0q+rgOGOFi5o=";
            }
            {
              name = "vscode-conventional-commits";
              publisher = "vivaxy";
              version = "1.26.0";
              sha256 = "Lj2+rlrKm9h21zEoXwa2TeGFNKBmlQKr7MRX0zgngdg=";
            }
            {
              name = "kdl";
              publisher = "kdl-org";
              version = "2.1.3";
              sha256 = "Jssmb5owrgNWlmLFSKCgqMJKp3sPpOrlEUBwzZSSpbM=";
            }
            {
              name = "sqlite-viewer";
              publisher = "qwtel";
              version = "25.12.2";
              sha256 = "KxVHIi1obeXaPR8cZhExvRHNV1DyDyphuGyd8R1ee28=";
            }
          ];
      };
    };
  };
}
