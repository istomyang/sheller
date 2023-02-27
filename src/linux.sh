#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib/git.sh

# shellcheck disable=SC1091
source lib/proxy.sh

# shellcheck disable=SC1091
source lib/shell.sh

#################################################################
#######                                                 #########
#######                     自定义                       #########
#######                                                 #########
#################################################################

# https://gist.github.com/vratiu/9780109
#PS1="\[\e[0;32m\]\W\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] "
PS1="\[\h \e[1;32m\]\W\[\e[0m\] \$ "

function s_close_screen() {
  # In server environment with screen, close screen with 1min not move.
  # https://blog.csdn.net/weixin_42114041/article/details/116832616
  setterm --blank 1
}

function s_close_screen_now() {
  setterm --blank force
}

function s_sleep() {
  systemctl suspend
}

function s_cpu_freq() {
  # Should install kernel-tools in fedora.
  cpupower frequency-info
}
