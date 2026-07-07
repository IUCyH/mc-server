#!/bin/bash
set -e

cd ~/mc-server
sudo docker exec mc-fabric-server rcon-cli /backup prune
