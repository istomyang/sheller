#!/usr/bin/env bash

alias mp="multipass"

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export PATH="$PATH:$HOME/env/flutter/bin"
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

# Go envs
go_ROOT="/Users/yangyang/Workspaces/Environment/golang"
export GOVERSION=go1.19.5
export GOROOT="$go_ROOT/$GOVERSION"
export GOPATH="$go_ROOT/gopath"
export GO111MODULE="on"
export GOPROXY="https://goproxy.cn,direct"
# 还可以设置不走 proxy 的私有仓库或组，多个用逗号相隔（可选）
export GOPRIVATE="git.mycompany.com,github.com/istomyang/private"
export GOSUMDB=off # 关闭校验 Go 依赖包的哈希值
PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
go_ROOT=""

# JAVA
# class file version 49 = Java 5
# class file version 50 = Java 6
# class file version 51 = Java 7
# class file version 52 = Java 8
# class file version 53 = Java 9
# class file version 54 = Java 10
# class file version 55 = Java 11
# class file version 56 = Java 12
# class file version 57 = Java 13
# class file version 58 = Java 14
export JAVA_8_HOME='/Users/yangyang/Library/Java/JavaVirtualMachines/corretto-1.8.0_312/Contents/Home'
export JAVA_11_HOME='/Users/yangyang/Library/Java/JavaVirtualMachines/corretto-11.0.15/Contents/Home'

alias jdk8='export JAVA_HOME=$JAVA_8_HOME'
alias jdk11='export JAVA_HOME=$JAVA_11_HOME'

export JAVA_HOME="$JAVA_11_HOME"

export PATH="$HOME/.cargo/bin:$PATH"
export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup

PATH="$PATH:$JAVA_HOME/bin"

function s_cf() {
	local dir="$HOME/env"
	chmod 0755 "$dir/cf.sh"
	"$dir/cf.sh"
}

SHELLER_PROXY_HOST="192.168.2.100"
SHELLER_PROXY_HTTP_PORT=10809
SHELLER_PROXY_SOCK_PORT=10808

# Exp: s_proxy_cmd_rm
function s_proxy_cmd_rm() {
	unset -v http_proxy https_proxy ALL_PROXY
	if [ "$1" != "-q" ]; then
		echo "unset cmdline's proxy successfully."
	fi
}

function s_proxy_cmd_host() {
	if [[ "$1" == "help" ]]; then
		echo "Exp: s_proxy_cmd_host 192.168.2.100"
		return
	fi
	s_proxy_cmd_rm -q
	export http_proxy="http://${SHELLER_PROXY_HOST}:${SHELLER_PROXY_HTTP_PORT}"
	export https_proxy="http://${SHELLER_PROXY_HOST}:${SHELLER_PROXY_HTTP_PORT}"
	export ALL_PROXY="socks5://${SHELLER_PROXY_HOST}:${SHELLER_PROXY_SOCK_PORT}"
	echo "set cmdline's proxy successfully with host: $SHELLER_PROXY_HOST."
}

function s_proxy_gui_host() {
	# All network devices name
	local networkservices=()
	local recover_ifs=$IFS
	local IFS=$'\n'
	for service in $(networksetup listallnetworkservices | tail -n +2); do
		# In mac, devices array start with 1.
		networkservices[$((${#networkservices[@]} + 1))]=$service
	done
	IFS=$recover_ifs

	for ((i = 1; i < $((${#networkservices[@]} + 1)); i++)); do
		local service=${networkservices[i]}
		networksetup -setwebproxy "$service" "$SHELLER_PROXY_HOST" "$SHELLER_PROXY_HTTP_PORT"
		networksetup -setwebproxystate "$service" on
		networksetup -setsecurewebproxy "$service" "$SHELLER_PROXY_HOST" "$SHELLER_PROXY_HTTP_PORT"
		networksetup -setsecurewebproxystate "$service" on
		networksetup -setsocksfirewallproxy "$service" "$SHELLER_PROXY_HOST" "$SHELLER_PROXY_SOCK_PORT"
		networksetup -setsocksfirewallproxystate "$service" on
	done

	echo "set gui's proxy successfully with host: $SHELLER_PROXY_HOST."
}

function s_proxy_gui_rm() {
	# All network devices name
	local networkservices=()
	local recover_ifs=$IFS
	local IFS=$'\n'
	for service in $(networksetup listallnetworkservices | tail -n +2); do
		# In mac, devices array start with 1.
		networkservices[$((${#networkservices[@]} + 1))]=$service
	done
	IFS=$recover_ifs

	for ((i = 1; i < $((${#networkservices[@]} + 1)); i++)); do
		local service=${networkservices[i]}
		networksetup -setwebproxy "$service" "" 0
		networksetup -setwebproxystate "$service" off
		networksetup -setsecurewebproxy "$service" "" 0
		networksetup -setsecurewebproxystate "$service" off
		networksetup -setsocksfirewallproxy "$service" "" 0
		networksetup -setsocksfirewallproxystate "$service" off
	done

	echo "set gui's proxy successfully with host: $SHELLER_PROXY_HOST."
}

# function git_clone() {
#     	if [[ "$1" == "help" ]]; then
# 		echo "Example: git_clone https://xxxxx.com --depth=1"
# 		return
# 	fi
#     git clone "https://ghproxy.com/$*"
# }
