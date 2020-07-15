#!/bin/bash

function replacePrivateKey() {
  # Copy the template to the file that will be modified to add the private key
  cp docker-compose-e2e-template.yaml docker-compose-e2e.yaml

  # The next steps will replace the template's contents with the
  # actual values of the private key file names for the two CAs.
  CURRENT_DIR=$PWD

  cd crypto-config/peerOrganizations/org2.sfiot.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml

}

export FABRIC_CFG_PATH=$PWD
#export BYFN_CA2_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org2.sfiot.com/ca && ls *_sk)


#replacePrivateKey
docker-compose -f docker-compose-cli.yaml up -d
#docker exec -it cli ./scripts/peer_add.sh
