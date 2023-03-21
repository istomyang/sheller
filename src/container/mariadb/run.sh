#!/usr/bin/env bash

S_CONTAINER_CMD="docker"

S_CONTAINER_MARIADB_IMAGE="bitnami/mariadb:latest"
S_CONTAINER_MARIADB_NAME="my-mariadb"
S_CONTAINER_MARIADB_USER="tom"
S_CONTAINER_MARIADB_PASS="tom"
S_CONTAINER_MARIADB_ROOT_PASS="tom"

function s_container_mariadb_run() {
  local h=${1:-""}
  if [[ "$h" == "--help" || "$h" == "-h" ]]; then
    cat <<'EOF'
Usage: s_container_mariadb_run [--rm]

Options:
  --rm  Delete container after stop it.
EOF
    return
  fi

  local rm_flag=""
  if [[ $1 == "--rm" ]]; then
    rm_flag="--rm"
  fi

  local network_name="mariadb-network"
  if ! "$S_CONTAINER_CMD" network ls | grep -iq $network_name; then
    "$S_CONTAINER_CMD" network create $network_name
  fi

  local image=${S_CONTAINER_MARIADB_IMAGE:-"mariadb:latest"}
  local name=${S_CONTAINER_MARIADB_NAME:-"my-mariadb"}
  local user=${S_CONTAINER_MARIADB_USER:-"tom"}
  local password=${S_CONTAINER_MARIADB_PASS:-"tom"}
  local root_password=${S_CONTAINER_MARIADB_ROOT_PASS:-"tom"}

  if ! "$S_CONTAINER_CMD" ps -a | grep -iq "$name"; then
    "$S_CONTAINER_CMD" run --detach --network $network_name -p 3306:3306 --name "$name-server" --env MARIADB_USER="$user" --env MARIADB_PASSWORD="$password" --env MARIADB_ROOT_PASSWORD="$root_password" $rm_flag "$image"
  else
    "$S_CONTAINER_CMD" start "$name" >/dev/null
  fi

  # while ! "$S_CONTAINER_CMD" ps --filter status=running --filter "name=my-mariadb-server"; do
  #   sleep 1
  # done

  while true; do
    # Use mariadb command will cause error.
    "$S_CONTAINER_CMD" run -it --name "$name-client" --network $network_name --rm "$image" mysql -h"$name-server" -u"$user" -p"$password" 2>/dev/null && break
    sleep 1
    echo "INFO: Don't wrong, just retry..."
  done
}

function s_container_mariadb_remove() {
  local name=${S_CONTAINER_MARIADB_NAME:-"my-mariadb-server"}
  "$S_CONTAINER_CMD" stop "$name-server" >/dev/null && echo "INFO: Success remove container"
}
