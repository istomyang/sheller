#!/usr/bin/env bash

# https://gist.github.com/vratiu/9780109
#PS1="\[\e[0;32m\]\W\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] "
PS1="\[\e[1;32m\]\W\[\e[0m\] \$ "

function s_see_func_usage() {
	declare -f "$@"
}

function c() {
	clear
}

################################################################
########################## History #############################
################################################################

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

function s_history_pause() {
	if [[ "$1" == "help" ]]; then
		echo "Pause history temporar in this session."
		return
	fi
	fc -p
}

function s_history_delete() {
	if [[ "$1" == "help" ]]; then
		echo "Delete history file."
		return
	fi
	history -c
}
