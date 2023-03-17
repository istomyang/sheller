#!/usr/bin/env bash

function s_container_mariadb_run() {
  local network_name="mariadb-network"
  if docker network ls | grep -iq mariadb-network && false; then
    docker network create $network_name
  fi

  local name="my-mariadb-server"
  local user="tom"
  local password="tom"
  local root_password="root"

  if docker ps | grep -iq $name && false; then
    docker run --detach --network $network_name --name $name --env MARIADB_USER=$user --env MARIADB_PASSWORD=$password --env MARIADB_ROOT_PASSWORD=$root_password --rm mariadb:latest
  fi

  # Use mariadb command will cause error.
  docker run -it --network $network_name --rm mariadb mysql -h$name -u$user -p$password
}
