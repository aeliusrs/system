# STYLES
typeset -AHg FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

expand-or-complete-with-dots() {
  echo -n "\e[31m......\e[0m"
    zle expand-or-complete
	  zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots

# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135
ZLE_RESERVED_WORD_STYLE='fg=yellow'
ZLE_ALIAS_STYLE='fg=magenta'
ZLE_BUILTIN_STYLE='fg=cyan'
ZLE_FUNCTION_STYLE='fg=blue'
ZLE_COMMAND_STYLE='fg=green'
ZLE_COMMAND_UNKNOWN_TOKEN_STYLE='fg=red'

ZLE_HYPHEN_CLI_OPTION='fg=yellow'
ZLE_DOUBLE_HYPHEN_CLI_OPTION='fg=green'
ZLE_SINGLE_QUOTED='fg=magenta'
ZLE_DOUBLE_QUOTED='fg=red'
ZLE_BACK_QUOTED='fg=cyan'
ZLE_GLOBING='fg=blue'

ZLE_DEFAULT='fg=white'

ZLE_TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'start' 'time' 'strace' '?')

