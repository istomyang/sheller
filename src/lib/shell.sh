#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib/common.sh

function s_see_func_usage() {
	declare -f "$@"
}

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
	rm -f "$HOME/.bash_history"
}
