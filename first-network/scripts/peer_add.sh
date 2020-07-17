#!/bin/bash

chmod -R 777 sfiot_new/

export CHANNEL_NAME=mychannel

peer channel create -o orderer.sfiot.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/sfiot.com/orderers/orderer.sfiot.com/msp/tlscacerts/tlsca.sfiot.com-cert.pem

peer channel join -b mychannel.block

CORE_PEER_ADDRESS=peer1.org1.sfiot.com:8051
CORE_PEER_LOCALMSPID="Org1MSP"

peer channel join -b mychannel.block

peer channel update -o orderer.sfiot.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/sfiot.com/orderers/orderer.sfiot.com/msp/tlscacerts/tlsca.sfiot.com-cert.pem

# Fetch channel.block and copy to other machines
#peer channel fetch newest mychannel.block -c mychannel --orderer orderer.sfiot.com:705
scp mychannel.block $(cat channel-artifacts/host.txt)/channel-artifacts

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.sfiot.com/users/Admin@org1.sfiot.com/msp
CORE_PEER_ADDRESS=peer0.org1.sfiot.com:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.sfiot.com/peers/peer0.org1.sfiot.com/tls/ca.crt

peer chaincode install -n sfiotcc -v 1.0 -p github.com/chaincode/sf_iot/

peer chaincode instantiate -o orderer.sfiot.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/sfiot.com/orderers/orderer.sfiot.com/msp/tlscacerts/tlsca.sfiot.com-cert.pem -C mychannel -n sfiotcc -v 1.0 -c '{"Args":["init"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer')"

sleep 5

#peer chaincode invoke -o orderer.sfiot.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/sfiot.com/orderers/orderer.sfiot.com/msp/tlscacerts/tlsca.sfiot.com-cert.pem -C mychannel -n sfiotcc --peerAddresses peer0.org1.sfiot.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.sfiot.com/peers/peer0.org1.sfiot.com/tls/ca.crt -c '{"Args":["save_data","E_1","12-02-05","N","200","01"]}'

#sleep 2

peer chaincode query -C mychannel -n sfiotcc -c '{"Args":["query_all"]}'

exit 1

sudo apt-get update

sudo apt install python3-pip

pip3 install --upgrade pip

sudo pip3 install pandas

cd sfiot_new

python3 control_channel_bc.py
