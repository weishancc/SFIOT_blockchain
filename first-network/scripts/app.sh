#!/bin/bash

function replacePrivateKey() {
  CURRENT_DIR=$PWD

  cd ../crypto-config/ordererOrganizations/sfiot.com/users/Admin@sfiot.com/msp/keystore/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  cd ..
  cp network-template.json network.json
  sed -i $OPTS "s/ORDERER_KEY/${PRIV_KEY}/g" network.json

  cd ./crypto-config/peerOrganizations/org1.sfiot.com/users/Admin@org1.sfiot.com/msp/keystore/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  cd ..
  sed -i $OPTS "s/ORG1A_KEY/${PRIV_KEY}/g" network.json

  cd ./crypto-config/peerOrganizations/org1.sfiot.com/users/User1@org1.sfiot.com/msp/keystore/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  cd ..
  sed -i $OPTS "s/ORG1U_KEY/${PRIV_KEY}/g" network.json
}

replacePrivateKey
python3 sfiot_app.py $1 $2
