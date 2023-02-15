#!/usr/bin/env bash

# shellcheck disable=SC2120
function sr_source_abs_path() {
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		cat <<'_EOF_'
sr_source_abs_path_0 will return your source file abs path to stdout.
_EOF_
		return
	fi

	local path="${BASH_SOURCE[0]}"
	if [[ "$path" =~ ^\. ]]; then
		path="$(pwd)${path:1}"
	fi
	echo "$path"
}
