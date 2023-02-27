#!/usr/bin/env bash

alias c="clear"

function su_check_help() {
	# Usage:
	# ```bash
	# su_check_help "$@"
	# if (($? == 1)); then
	#   echo "YES"
	#		return
	# fi
	# ```
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		return 1
	fi
}

function s_reload() {
	# shellcheck disable=SC1090
	. ~/.bashrc
}