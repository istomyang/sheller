#!/usr/bin/env bash

S_CONTAINER_CMD="docker"

S_CONTAINER_REDIS_SHELL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P && cd - >>/dev/null || exit)"
S_CONTAINER_REDIS_DB_DIR="$S_CONTAINER_REDIS_SHELL_DIR/db"
S_CONTAINER_REDIS_CONF="$S_CONTAINER_REDIS_SHELL_DIR/redis7.conf"
S_CONTAINER_REDIS_IMAGE="bitnami/redis:latest"
S_CONTAINER_REDIS_NAME="my-redis"

function s_container_redis_run() {
  echo "INFO: Persisting Volume at $S_CONTAINER_REDIS_DB_DIR"
  echo "INFO: Redis Configuation file at $S_CONTAINER_REDIS_CONF"

  local vol="$S_CONTAINER_REDIS_DB_DIR:/bitnami/redis/data"
  local conf="$S_CONTAINER_REDIS_CONF:/opt/bitnami/redis/mounted-etc/redis.conf"

  local network_name="redis-network"
  if ! "$S_CONTAINER_CMD" network ls | grep -iq $network_name; then
    "$S_CONTAINER_CMD" network create $network_name
  fi

  local image=${S_CONTAINER_REDIS_IMAGE:-"bitnami/redis:latest"}
  local name=${S_CONTAINER_REDIS_NAME:-"my-redis"}
  local name_client="$name-client"
  local name_server="$name-server"

  if ! "$S_CONTAINER_CMD" ps -a | grep -iq "$name_server"; then
    "$S_CONTAINER_CMD" run -d --name "$name_server" \
      -e ALLOW_EMPTY_PASSWORD=yes \
      -p 6379:6379 \
      -v "$vol" \
      -v "$conf" \
      --network $network_name \
      "$image"
  else
    "$S_CONTAINER_CMD" start "$name_server" >/dev/null
  fi

  while true; do
    "$S_CONTAINER_CMD" run -it --rm \
      --name "$name_client" \
      --network $network_name \
      "$image" redis-cli -h "$name_server" 2>/dev/null && break
    sleep 1
    echo "INFO: Don't wrong, just retry..."
  done
}

function s_container_redis_remove() {
  local name=${S_CONTAINER_REDIS_NAME:-"my-redis"}
  "$S_CONTAINER_CMD" stop "$name-server" >/dev/null && echo "INFO: Success remove container"
}
