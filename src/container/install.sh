#!/usr/bin/env bash

function _s_container_install() {
  local cur_dir=
  cur_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P && cd - >>/dev/null || exit)"
  local target_dir="$cur_dir/$1"
  # shellcheck disable=SC1091
  . "$target_dir/run"
}

function s_container_install_redis() {
  _s_container_install redis
}

function s_container_install_mariadb() {
  _s_container_install mariadb
}
