#!/usr/bin/env bash

VAL=$(tmux show-options -w | grep 'synchronize-panes.*on')

#echo $VAL

if [[ $VAL = '' ]];
then 
	SWT='on'
else
	SWT='off'
fi;

tmux set-option -w synchronize-panes $SET > /dev/null
