{
  pkgs,
  config,
  inputs,
  ...
}:
{
  users.users.sophia.packages = with pkgs; [
    easyeffects
    fluffychat
    # thunderbird-latest-unwrapped
  ];

  home-manager.users.sophia = {
    imports = [
      inputs.nixcord.homeModules.nixcord
    ];

    programs.nixcord = {
      enable = true;
      discord.enable = false;
      equibop.enable = true;
      config = {
        enableReactDevtools = true;
        autoUpdate = true;
        autoUpdateNotification = true;
        plugins = {
          betterGifAltText.enable = true;
          callTimer.enable = true;
          consoleShortcuts.enable = true;
          experiments.enable = true;
          fakeProfileThemes.enable = true;
          fixImagesQuality.enable = true;
          fixSpotifyEmbeds.enable = true;
          fixYoutubeEmbeds.enable = true;
          fullSearchContext.enable = true;
          mentionAvatars.enable = true;
          noDevtoolsWarning.enable = true;
          noF1.enable = true;
          reactErrorDecoder.enable = true;
          sortFriendRequests.enable = true;
          spotifyCrack.enable = true;
          themeAttributes.enable = true;
          unindent.enable = true;
          unlockedAvatarZoom.enable = true;
          userMessagesPronouns.enable = true;
          USRBG.enable = true;
          validUser.enable = true;
          viewIcons.enable = true;
          voiceChatDoubleClick.enable = true;
          volumeBooster.enable = true;
          youtubeAdblock.enable = true;
          webKeybinds.enable = true;
          alwaysTrust.enable = true;
          ClearURLs.enable = true;
          disableCallIdle.enable = true;
          implicitRelationships.enable = true;
          messageLatency.enable = true;
          noUnblockToJump.enable = true;
          oneko.enable = true;
          webScreenShareFixes.enable = true;
          XSOverlay.enable = config.soph.vr.enable;
        };
      };
    };
  };
}
