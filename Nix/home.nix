{ config, pkgs, ... }:

{
  home.username = "aeliusrs";
  home.homeDirectory = "/home/aeliusrs";

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
  ];

 #xsession.enable = true;
 #xsession.windowManager.openbox.enable = true;

  programs.zsh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "aeliusrs";
    userEmail = "asrs.contact+dev@gmail.com";
  };
}
