# 1-options.zsh
autoload -Uz colors && colors
autoload -U vcs_info && vcs_info
#autoload -Uz compinit -i && compinit
autoload -Uz compinit -i; compinit
autoload -U zmv

export LSCOLOR="Gxfxcxdxbxegedabagacad"
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=5000
export SAVEHIST=5000
export HISTDUP=erase

zmodload zsh/stat
zmodload zsh/complist

eval "$(dircolors -b)"
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
 zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

unsetopt menu_complete
unsetopt flowcontrol

setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt prompt_subst
setopt extended_glob
setopt correct
setopt autocd
setopt noclobber
setopt no_case_glob
setopt prompt_cr
setopt prompt_sp
setopt local_options null_glob
#setopt HIST_IGNORE_DUPS
#setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
#setopt HIST_VERIFY
#setopt HIST_SAVE_NO_DUPS
#setopt HIST_EXPIRE_DUPS_FIRST
#setopt HIST_FIND_NO_DUPS
setopt appendhistory
setopt sharehistory
setopt incappendhistory
