#!/usr/bin/env bash

alias c="clear"

export USER_SU_PASSWORD=""

function su_sudo() {
	if [[ -z "$USER_SU_PASSWORD" ]]; then
		read -r -p "Enter your sudo password: " USER_SU_PASSWORD
	fi
	echo "$USER_SU_PASSWORD" | sudo -S "$@"
}

function su_check_help() {
	# Usage:
	# ```bash
	# su_check_help "$@"
	# if (($? == 1)); then
	#   echo "YES"
	#		return
	# fi
	# ```
	local h=${1:-"-h"}
	if [[ "$h" == "--help" || "$h" == "-h" ]]; then
		return 1
	fi
}

function s_reload() {
	# shellcheck disable=SC1090
	. ~/.bashrc
}
