#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME=${1:-"mc-fabric-server"}

cd $SCRIPT_DIR
sudo docker exec $CONTAINER_NAME rcon-cli /backup prune && docker exec $CONTAINER_NAME bash -c "cd /data/world && git config --global --add safe.directory /data/world && git gc"
echo "Backup cleanup complete"