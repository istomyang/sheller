#!/usr/bin/env bash

# shellcheck disable=SC1091
source lib/common.sh

function s_install_docker_config() {
  local path="/etc/docker/daemon.json"
  if [[ -e "$path" ]]; then
    echo "Warning: $path is exist, abort operation."
    return
  fi

  read -r -d '' content <<'_EOF_'
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
_EOF_

  su_sudo sh -c "echo '$content' | tee -a $path >> /dev/null"

  echo "Ok!" && cat "$path"
}

function s_install_podman_config() {
  local path="$HOME/.config/containers/registries.conf"
  if [[ -e "$path" ]]; then
    echo "Warning: $path is exist, abort operation."
    return
  fi

  read -r -d '' content <<'_EOF_'
unqualified-search-registries = ["docker.io"]

[[registry]]
prefix = "docker.io"
location = "hub-mirror.c.163.com"
[[registry.mirror]]
location = "mirror.baidubce.com"
_EOF_

  echo "$content" | tee -a "$path" >>/dev/null

  echo "Ok!" && cat "$path"
}
