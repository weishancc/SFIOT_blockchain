#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# This script is designed to be run in the cli container as the third
# step of the EYFN tutorial. It installs the chaincode as version 2.0
# on peer0.org1 and peer0.org2, and uprage the chaincode on the
# channel to version 2.0, thus completing the addition of org4 to the
# network previously setup in the BYFN tutorial.
#

CHANNEL_NAME="mychannel"
ORDERER_CA="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/sfiot.com/orderers/orderer.sfiot.com/msp/tlscacerts/tlsca.sfiot.com-cert.pem"

# import utils
. scripts/utils.sh

peer channel fetch config config_block.pb -o orderer.sfiot.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json

jq '.channel_group.groups.Application.groups.Org3MSP.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "peer0.org4.sfiot.com","port": 14051}]},"version": "0"}}' config.json > modified_anchor_config.json

configtxlator proto_encode --input config.json --type common.Config --output config.pb

configtxlator proto_encode --input modified_anchor_config.json --type common.Config --output modified_anchor_config.pb

configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_anchor_config.pb --output anchor_update.pb

configtxlator proto_decode --input anchor_update.pb --type common.ConfigUpdate | jq . > anchor_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL_NAME'", "type":2}},"data":{"config_update":'$(cat anchor_update.json)'}}}' | jq . > anchor_update_in_envelope.json

configtxlator proto_encode --input anchor_update_in_envelope.json --type common.Envelope --output anchor_update_in_envelope.pb

peer channel update -f anchor_update_in_envelope.pb -c $CHANNEL_NAME -o orderer.sfiot.com:7050 --tls --cafile $ORDERER_CA

docker logs -f peer0.org1.sfiot.com

echo
echo "========= Finished updating Org4 anchor peer! ========= "
echo

exit 0
