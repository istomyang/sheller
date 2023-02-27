#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib/common.sh

# shellcheck disable=SC1091
source lib/git.sh

# shellcheck disable=SC1091
source lib/shell.sh

# shellcheck disable=SC1091
source lib/proxy.sh

function s_proxy_gui_set() {
	# All network devices name
	local networkservices=()
	local recover_ifs=$IFS
	local IFS=$'\n'
	for service in $(networksetup listallnetworkservices | tail -n +2); do
		# In mac, devices array start with 1.
		networkservices[$((${#networkservices[@]} + 1))]=$service
	done
	IFS=$recover_ifs

	local host=${1:-$PROXY_DEFAULT_HOST}
	local port=${2:-$PROXY_DEFAULT_PORT}

	for ((i = 1; i < $((${#networkservices[@]} + 1)); i++)); do
		local service=${networkservices[i]}
		networksetup -setwebproxy "$service" "$host" "$port"
		networksetup -setwebproxystate "$service" on
		networksetup -setsecurewebproxy "$service" "$host" "$port"
		networksetup -setsecurewebproxystate "$service" on
		networksetup -setsocksfirewallproxy "$service" "$host" "$port"
		networksetup -setsocksfirewallproxystate "$service" on
	done

	echo "OK! ($host:$port)"
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

	echo "OK!"
}

#################################################################
#######                                                 #########
#######                     自定义                       #########
#######                                                 #########
#################################################################

# https://gist.github.com/vratiu/9780109
#PS1="\[\e[0;32m\]\W\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] "
PS1="\[\e[1;32m\]\W\[\e[0m\] \$ "

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
	local dir="$HOME"
	chmod 0755 "$dir/cf.sh"
	"$dir/cf.sh"
}
