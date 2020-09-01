#!/bin/bash

function replacePrivateKey() {
  CURRENT_DIR=$PWD

  cd crypto-config/peerOrganizations/org1.sfiot.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed -i $OPTS "s/BYFN_CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-ca.yaml

}

export FABRIC_CFG_PATH=$PWD

sudo ../bin/cryptogen generate --config=./crypto-config.yaml

sudo ../bin/configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=mychannel  && sudo ../bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

sudo ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

sudo ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

sudo ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP


#Save the PATH to other Machines/Orgs) and copy materials
echo $ORG2_PATH > ./channel-artifacts/host2.txt
sudo scp -r crypto-config channel-artifacts $ORG2_PATH
echo $ORG3_PATH > ./channel-artifacts/host3.txt
sudo scp -r crypto-config channel-artifacts $ORG3_PATH

replacePrivateKey
docker-compose -f docker-compose-ca.yaml -f docker-compose-cli.yaml -f docker-compose-couch.yaml up -d
docker exec -it cli ./scripts/peer_add.sh
