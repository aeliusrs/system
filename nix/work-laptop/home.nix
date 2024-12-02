{
  config,
  pkgs,
  lib,
  ...
}:
let
  myuser = "aeliusrs";
  repository = "/home/${myuser}/.system";
in
{

  # Fetch Git repository
  #  home.activation.getRepository = lib.hm.dag.entryBefore ["checkFilesChanged"] ''
  #    PATH=$PATH:${lib.makeBinPath [ pkgs.git ]}
  #    git -C ${builtins.toString repository} pull
  #  '';
  #    || ${pkgs.git}/bin/git clone https://github.com/aeliusrs/system.git ${builtins.toString repository}

  home.username = "${myuser}";
  home.homeDirectory = "/home/${myuser}";

  home.enableNixpkgsReleaseCheck = false;

  home.keyboard = {
    layout = lib.mkForce "us";
    ### this does not work, rely on ~/.scripts/kb-layout
    # options = lib.mkForce [
    #   "caps:swapcaps"
    #   "compose:ralt"
    # ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    alacritty
    ansible
    appimage-run # to run appimage
    bc
    blueman
    brave
    btop
    chromium
    dmenu
    feh
    firefox
    fzf
    galculator
    gcolor3
    gcolor3
    git
    gnumake # to have make !
    gnutar
    gparted
    i3lock
    imagemagick
    jq
    killall
    lxappearance-gtk2
    lxde.lxrandr
    mate.mate-polkit
    mate.mate-utils
    neovim
    networkmanagerapplet
    obconf
    openbox
    openbox-menu
    opentofu
    pavucontrol
    pcmanfm
    picom
    polybar
    python312Packages.pygobject3 # dmenu_network dep
    qjackctl
    redshift # change color3500
    shellcheck
    soundconverter
    sshfs
    terminus-nerdfont
    terminus_font
    tmux
    transmission_4-gtk
    ueberzugpp
    unifont
    unzip
    viewnior
    vimix-icon-theme
    virt-manager
    virt-viewer
    vlc
    vscodium
    wget
    wmctrl
    wmname
    xclip
    xdotool
    yazi
    youtube-music
    yt-dlp
    zathura
    zip
    zsh
  ];

  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    # userName = "aeliusrs";
    # userEmail = "asrs.contact+dev@gmail.com";
    userName = "clement.richard";
    userEmail = "clement.richard@n-hop.com";
    # extraConfig = {
    # credential.helper = "store";
    # };
  };

  # ========================================================================= #
  # ------------------------------------------------------------------------- #
  # Install Dotfiles

  home.file.".zshrc".enable = false; # remove zshrc linking from HM

  home.activation.setDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ## HOME-MANAGER
    mkdir -p ~/.config/home-manager
    ln -fs ${repository}/nix/work-laptop/home.nix ~/.config/home-manager/home.nix

    ## ZSH
    ln -fs ${repository}/dotfiles/zsh/zshrc       ~/.zshrc
    ln -fsT ${repository}/dotfiles/zsh/ocha-zsh    ~/.ocha-zsh
    chmod -Rv u+w ~/.ocha-zsh || :
    chmod -Rv u+w ~/.zshrc || :

    ## TMUX
    ln -fs ${repository}/dotfiles/tmux/tmux.conf  ~/.tmux.conf
    ln -fsT ${repository}/dotfiles/tmux/tmux       ~/.tmux
    chmod -Rv u+w ~/.tmux || :
    chmod -Rv u+w ~/.tmux.conf || :


    ## SCRIPTS
    ln -fsT ${repository}/dotfiles/scripts         ~/.scripts

    ## GTK2
    ln -fs ${repository}/dotfiles/gtkrc-2.0       ~/.gtkrc-2.0

    ## MIMEAPPS
    ln -fs ${repository}/dotfiles/mimeapps.list   ~/.config/

    ## ALACRITTY
    ln -fs ${repository}/dotfiles/alacritty       ~/.config/

    ## NVIM
    ln -fs ${repository}/dotfiles/nvim            ~/.config/

    ## OPENBOX
    ln -fs ${repository}/dotfiles/openbox         ~/.config/

    ## PICOM
    ln -fs ${repository}/dotfiles/picom           ~/.config/

    ## POLYBAR
    ln -fs ${repository}/dotfiles/polybar         ~/.config/

    ## GTK3
    ln -fs ${repository}/dotfiles/gtk-3.0         ~/.config/
  '';

  # ========================================================================= #
  # ------------------------------------------------------------------------- #
  # Install Assets

  home.activation.setAssets = lib.hm.dag.entryAfter [ "setDotfiles" ] ''
    mkdir -p ~/.local/share/fonts
    cp -u ${repository}/dotfiles/Xresources ~/.Xresources || :
    cp -ru ${repository}/assets/fonts       ~/.local/share/ || :
    cp -ru ${repository}/assets/icons       ~/.icons/ || :
    cp -ru ${repository}/assets/themes      ~/.themes/ || :
  '';

  home.activation.nvimSetup = lib.hm.dag.entryAfter [ "setAssets" ] ''
    PATH=$PATH:${
      lib.makeBinPath [
        pkgs.neovim
        pkgs.git
        pkgs.python311
      ]
    }
    nvim --headless +'PlugInstall' +qa || :
    nvim --headless +'UpdateRemotePlugins' +qa || :
  '';
}
