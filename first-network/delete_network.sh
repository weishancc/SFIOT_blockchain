#!/bin/bash

docker-compose -f docker-compose-cli.yaml -f docker-compose-etcdraft2.yaml -f docker-compose-couch.yaml -f docker-compose-org4.yaml down --volumes --remove-orphans

docker stop $(docker ps -aq)

docker rm $(docker ps -aq)

service docker restart

docker volume prune

sudo ./byfn.sh down
