#!/usr/bin/env bash

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
