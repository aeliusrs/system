{ config, pkgs, lib, ... }:
let
  repository = ~/.system;
  myuser = "aeliusrs";
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
  home.stateVersion = "23.11";

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
    gcolor2
    git
    gnumake #to have make !
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
    pavucontrol
    pcmanfm
    picom
    polybar
    python311Packages.pygobject3 # dmenu_network dep
    qjackctl
    redshift #change color3500
    shellcheck
    soundconverter
    sshpass
    terminus-nerdfont
    terminus_font
    terraform
    tmux
    transmission
    unifont
    unzip
    vagrant
    viewnior
    vimix-icon-theme
    virt-manager
    virt-viewer
    vlc
    wget
    wmctrl
    wmname
    xclip
    xdotool
    youtube-music
    yt-dlp
    zathura
    zip
    zsh
    sshfs
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];


  #programs.home-manager.enable = true;

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    userName = "aeliusrs";
    userEmail = "asrs.contact+dev@gmail.com";
    # extraConfig = {
      # credential.helper = "store";
    # };
  };



  # ========================================================================= #
  # ------------------------------------------------------------------------- #
  # Install Dotfiles

  # remove linking from HM to zshrc
  home.file.".zshrc".enable = false;

  home.activation.setDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
  ## ZSH
  cp -f ${repository}/dotfiles/zsh/zshrc       ~/.zshrc
  cp -rf ${repository}/dotfiles/zsh/ocha-zsh   ~/.ocha-zsh/
  chmod -Rv u+w ~/.ocha-zsh
  chmod -Rv u+w ~/.zshrc

  ## TMUX
  cp -f ${repository}/dotfiles/tmux/tmux.conf  ~/.tmux.conf
  cp -rf ${repository}/dotfiles/tmux/tmux      ~/.tmux/
  chmod -Rv u+w ~/.tmux
  chmod -Rv u+w ~/.tmux.conf

  ## SCRIPTS
  cp -rf ${repository}/dotfiles/scripts        ~/.scripts/
  chmod -Rv u+w ~/.scripts

  ## GTK2
  cp -f ${repository}/dotfiles/gtkrc-2.0       ~/.gtkrc-2.0
  chmod -Rv u+w ~/.gtkrc-2.0

  ## MIMEAPPS
  cp -f ${repository}/dotfiles/mimeapps.list   ~/.config/

  ## ALACRITTY
  cp -rf ${repository}/dotfiles/alacritty      ~/.config/

  ## NVIM
  cp -rf ${repository}/dotfiles/nvim           ~/.config/

  ## OPENBOX
  cp -rf ${repository}/dotfiles/openbox        ~/.config/

  ## PICOM
  cp -rf ${repository}/dotfiles/picom          ~/.config/

  ## POLYBAR
  cp -rf ${repository}/dotfiles/polybar        ~/.config/

  ## GTK3
  cp -rf ${repository}/dotfiles/gtk-3.0        ~/.config/

  chmod -Rv u+w ~/.config
  '';

  # ========================================================================= #
  # ------------------------------------------------------------------------- #
  # Install Assets

  home.activation.setAssets = lib.hm.dag.entryAfter ["setDotfiles"] ''
    mkdir -p ~/.local/share/fonts
    cp -u ${repository}/dotfiles/Xresources ~/.Xresources || :
    cp -ru ${repository}/assets/fonts       ~/.local/share/ || :
    cp -ru ${repository}/assets/icons       ~/.icons/ || :
    cp -ru ${repository}/assets/themes      ~/.themes/ || :
    chmod -R +w ~/.Xresources || :
    chmod -R +w ~/.local/share/fonts || :
    chmod -R +w ~/.icons || :
    chmod -R +w ~/.themes || :
  '';

  home.activation.nvimSetup = lib.hm.dag.entryAfter ["setAssets"] ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.neovim pkgs.git pkgs.python311 ]}
    nvim --headless +'PlugInstall' +qa || :
    nvim --headless +'UpdateRemotePlugins' +qa || :
  '';
}

