#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib/common.sh

function s_proxy_set() {
	su_check_help "$@"
	if (($? == 1)); then
		cat <<'EOF'
Usage: s_proxy_set 192.168.2.100 7890
			 s_proxy_set 192.168.2.100 7890 7891

Note:
	Must ensure http/https use same host:port.
	You can use `declare -f func_name` to see definition.
EOF
		return
	fi

	local host=${1:-""}
	local port=${2:-""}
	local s_port=${3:-$port}
	export http_proxy="http://$host:$port"
	export HTTP_PROXY="http://$host:$port"
	export https_proxy="http://$host:$port"
	export HTTPS_PROXY="http://$host:$port"
	export ALL_PROXY="socks5://$host:$s_port"
	export all_proxy="socks5://$host:$s_port"
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

function s_proxy_after_set_minikube() {
	export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.59.0/24,192.168.49.0/24,192.168.39.0/24
}
