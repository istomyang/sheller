#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib/common.sh

PROXY_DEFAULT_HOST="192.168.2.100"
PROXY_DEFAULT_PORT=10809 # should ensure same port with http and https.

function s_proxy_set() {
	su_check_help "$@"
	if (($? == 1)); then
		cat <<'EOF'
Usage: s_proxy_set 192.168.2.100 7890

Note:
	Must ensure http/https use same host:port.
	You can use `declare -f func_name` to see definition.
EOF
		return
	fi

	local host=${1:-$PROXY_DEFAULT_HOST}
	local port=${1:-$PROXY_DEFAULT_PORT}
	export http_proxy="http://$host:$port"
	export HTTP_PROXY="http://$host:$port"
	export https_proxy="http://$host:$port"
	export HTTPS_PROXY="http://$host:$port"
	export ALL_PROXY="socks5://$host:$port"
	export all_proxy="socks5://$host:$port"
	echo "OK!"
}

function s_proxy_get() {
	cat <<EOF
Proxy list:
http_proxy(also capital): $http_proxy
https_proxy(also capital): $https_proxy
ALL_PROXY: $ALL_PROXY
EOF
}

function s_proxy_rm() {
	unset -v http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ALL_PROXY all_proxy
	echo "OK!"
}

function s_proxy_check_google() {
	curl -X GET -I "www.google.com"
}

function s_proxy_print_cmd() {
	echo "export https_proxy=${https_proxy} http_proxy=${https_proxy} all_proxy=${all_proxy}"
}
