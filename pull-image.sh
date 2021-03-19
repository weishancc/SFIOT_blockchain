#!bin/bash

# Pull images
docker pull zakialam/fabric-ca:arm64-1.4.1 &&
docker pull ptunstad/fabric-tools:arm64-1.4.1 &&
docker pull ptunstad/fabric-ccenv:arm64-1.4.1 &&
docker pull ptunstad/fabric-peer:arm64-1.4.1 &&
docker pull zakialam/fabric-orderer:arm64-1.4.1 &&
docker pull ptunstad/fabric-couchdb:arm64-1.4.1 &&
docker pull ptunstad/fabric-baseimage:arm64-0.4.15 &&

# Tag images
docker tag zakialam/fabric-ca:arm64-1.4.1 hyperledger/fabric-ca:arm64-1.4.1 &&
docker tag ptunstad/fabric-tools:arm64-1.4.1 hyperledger/fabric-tools:arm64-1.4.1 &&
docker tag ptunstad/fabric-ccenv:arm64-1.4.1 hyperledger/fabric-ccenv:latest &&
docker tag ptunstad/fabric-peer:arm64-1.4.1 hyperledger/fabric-peer:arm64-1.4.1 &&
docker tag zakialam/fabric-orderer:arm64-1.4.1 hyperledger/fabric-orderer:arm64-1.4.1 &&
docker tag ptunstad/fabric-couchdb:arm64-1.4.1 hyperledger/fabric-couchdb:arm64-0.4.15 &&
docker tag ptunstad/fabric-baseimage:arm64-0.4.15 hyperledger/fabric-baseimage:arm64-0.4.15
