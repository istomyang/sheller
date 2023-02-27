#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib/common.sh

function s_git_in() {
	su_check_help "$@"
	if (($? == 1)); then
		echo "Check whether in git dir or not."
		return
	fi

	if [[ "$(git status 2>&1)" == "fatal: not a git repository"* ]]; then
		echo "Result: Not in git dir."
		return
	fi
	echo "Result: In git dir."
}
