alias open="xdg-open"

alias -- -='cd -'

alias -g ...='cd ../..'
alias -g ....='cd ../../..'
alias -g .....='cd ../../../..'
alias -g ......='cd ../../../../..'
alias -g .......='cd ../../../../../..'

alias gst='git status'
alias gcl='git clone'
alias ga='git add'
alias gaa='git add -all'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gca='git commit -a'

alias ls='ls --color=tty'

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lt='tree | less'
alias lla='ls -lh -a'
alias lll='ls -lh | less'

alias grep='grep --color=tty'

alias gcw='gcc -Wall -Werror -Wextra'

alias vi='nvim'
alias vim='nvim'
alias vall='nvim -p *'
alias vic='nvim -p *.c'

alias valflag='valgrind --leak-check=full --show-leak-kind=all'

alias chkyb='setxkbmap -option caps:swapescape'
alias chcon='ping -c 1 8.8.8.8'
alias chdeb='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'

alias tmat='tmux attach -t'
alias tls='tmux ls'
alias sdup='sudo zypper dup --no-recommends'
alias :q='exit'
alias record-video='ffmpeg -f x11grab -y -r 30 -s 1920x1080 -i :0.0 -vcodec huffyuv out.avi'


function grepa(){
	grep -A $1 $2 **/** 2> /dev/null
}
function lsgr(){
	if [ -z $1 ]
	then
		echo "Usage lsgr [word]"
	fi
	ls -a | grep $1
}
function psgr(){
	if [ -z $1 ]
	then
		echo "Usage psgr [word]"
	fi
	ps -aux | grep $1
}
function vif(){
	nvim -p $(find . -name $1);
}
function seek(){
	grep -A 0 $1 **/**/** 2> /dev/null
}
function rme(){
	find . -type f -not -name "$1" -delete
}
