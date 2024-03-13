#!/bin/bash

echo "----------------------------"
echo "-- Updating environment --"
echo "----------------------------"
apt update -y
apt install -y nano git zip unzip jq curl figlet

figlet "Installing Docker"
apt install -y docker.io

figlet "Installing Docker Compose"
apt install -y docker-compose

figlet "Removing images and containers"
docker system prune -a -f

docker_compose_file=/portainer/docker/docker-compose.yml

figlet "Starting service"
docker-compose -f $docker_compose_file up
