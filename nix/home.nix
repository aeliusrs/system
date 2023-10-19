{ config, pkgs, lib, ... }:
let
  repository = ~/.system;
in
{

  # Fetch Git repository
#  home.activation.getRepository = lib.hm.dag.entryAfter ["checkFilesChanged"] ''
#    ${pkgs.git}/bin/git -C ${builtins.toString repository} pull || ${pkgs.git}/bin/git clone https://github.com/aeliusrs/system.git ${builtins.toString repository}
#  '';

  home.username = "oolong";
  home.homeDirectory = "/home/oolong";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    neovim
    zsh
    git
    openbox
    openbox-menu
    obconf
    pcmanfm
    mate.mate-utils
    mate.mate-polkit
    alacritty
    vlc
    brave
    zathura
    xclip
    xdotool
    wmctrl
    wmname
    imagemagick
    gcolor3
    galculator
    viewnior
    transmission
    soundconverter
    lxde.lxrandr
    lxappearance-gtk2
    i3lock
    polybar
    mate.mate-polkit
    picom
    feh
    unifont
    terminus_font
    terminus-nerdfont
    tmux
    zip
    unzip
    wget
    bc
    jq
    gnutar
    dmenu
    sshpass
  ];

 #xsession.enable = true;
 #xsession.windowManager.openbox.enable = true;

  programs.zsh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "oolong";
    userEmail = "asrs.contact+dev@gmail.com";
  };

  # ========================================================================= #
  # ------------------------------------------------------------------------- #
  # Install Dotfiles

  ## ZSH
  home.file.".zshrc".source = "${repository}/dotfiles/zsh/zshrc";
  home.file.".ocha-zsh" = {
    source = "${repository}/dotfiles/zsh/ocha-zsh";
    recursive = true;
    force = true;
  };

  ## TMUX
  home.file.".tmux.conf".source = "${repository}/dotfiles/tmux/tmux.conf";
  home.file.".tmux" = {
    source = "${repository}/dotfiles/tmux/tmux";
    recursive = true;
    force = true;
  };

  ## MIMEAPPS
  home.file.".config/mimeapps.list".source = "${repository}/dotfiles/mimeapps.list";

  ## ALACRITTY
  home.file.".config/alacritty" = {
    source = "${repository}/dotfiles/alacritty";
    recursive = true;
    force = true;
  };

  ## NVIM
  home.file.".config/nvim" = {
    source = "${repository}/dotfiles/nvim";
    recursive = true;
    force = true;
  };

  ## SCRIPTS
  home.file.".scripts" = {
    source = "${repository}/dotfiles/scripts";
    recursive = true;
    force = true;
  };

  ## OPENBOX
  home.file.".config/openbox" = {
    source = "${repository}/dotfiles/openbox";
    recursive = true;
    force = true;
  };

  ## PICOM
  home.file.".config/picom" = {
    source = "${repository}/dotfiles/picom";
    recursive = true;
    force = true;
  };

  ## POLYBAR
  home.file.".config/polybar" = {
    source = "${repository}/dotfiles/polybar";
    recursive = true;
    force = true;
  };

  # ========================================================================= #
  # ------------------------------------------------------------------------- #
  # Install Assets

  home.activation.getRepository = lib.hm.dag.entryAfter ["checkFilesChanged"] ''
    cp -rf ${repository}/assets/fonts ~/.local/share/fonts
    cp -rf ${repository}/assets/icons ~/.icons
    cp -rf ${repository}/assets/themes ~/.themes
  '';

}

