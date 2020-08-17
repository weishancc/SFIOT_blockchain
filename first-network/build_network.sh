#!/bin/bash

function replacePrivateKey() {
  # Copy the template to the file that will be modified to add the private key
  cp docker-compose-e2e-template.yaml docker-compose-e2e.yaml

  # The next steps will replace the template's contents with the
  # actual values of the private key file names for the two CAs.
  CURRENT_DIR=$PWD

  cd crypto-config/peerOrganizations/org1.sfiot.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml

}

export FABRIC_CFG_PATH=$PWD
#export BYFN_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.sfiot.com/ca && ls *_sk)

#Testing

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

#End

#replacePrivateKey
docker-compose -f docker-compose-cli.yaml -f docker-compose-couch.yaml up -d
docker exec -it cli ./scripts/peer_add.sh
