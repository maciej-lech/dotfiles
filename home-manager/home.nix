{ config, lib, pkgs, systemSettings, userSettings, ... }:

let
  nixGLWrap = wrap: pkg:
    pkgs.runCommand "${pkg.name}-nixgl-wrapper" { } ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
       wrapped_bin=$out/bin/$(basename $bin)
       echo "exec ${lib.getExe wrap} $bin \$@" > $wrapped_bin
       chmod +x $wrapped_bin
      done
    '';

  nixGLIntelWrap = pkg: nixGLWrap pkgs.nixgl.nixGLIntel pkg;

  nixVulkanIntelWrap = pkg: nixGLWrap pkgs.nixgl.nixVulkanIntel pkg;
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = userSettings.homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    nixgl.nixGLIntel
    nixgl.nixVulkanIntel

    adwaita-fonts
    nerd-fonts.adwaita-mono
    nerd-fonts.jetbrains-mono

    babelfish
    bat
    broot
    direnv
    eza
    fd
    fzf
    rclone
    wtfis

    awscli2
    gh
    gitlab-ci-local
    glab
    go-task

    nil
    nix-direnv
    nixd
    nixfmt

    uv

    pm2

    (nixGLIntelWrap brave)
    (nixGLIntelWrap ghostty)
    (nixGLIntelWrap mumble)
    (nixGLIntelWrap obsidian)
    (nixVulkanIntelWrap zed-editor)
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/maciek/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Style
  stylix = {
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    image = ./assets/w343434.png;
    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      monospace = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  fonts.fontconfig = { enable = true; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Update XDG_DATA_DIRS
  targets.genericLinux.enable = true;

  news.display = "silent";
}
