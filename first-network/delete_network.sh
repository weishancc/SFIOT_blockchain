#!/bin/bash

docker-compose -f docker-compose-cli.yaml down --volumes --remove-orphans

docker stop $(docker ps -aq)

docker rm $(docker ps -aq)

service docker restart

docker volume prune

docker network prune

rm -rf channel-artifacts

sudo ./byfn.sh down
