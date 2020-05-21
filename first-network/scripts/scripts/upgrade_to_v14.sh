#!/bin/bash


# import utils
. scripts/utils.sh

CHANNEL_NAME="mychannel"
ORDERER_CA="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/sfiot.com/orderers/orderer.sfiot.com/msp/tlscacerts/tlsca.sfiot.com-cert.pem"

peer channel fetch config config_block.pb -o orderer.sfiot.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json

jq '.channel_group.groups.Application.groups.Org4MSP.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "peer0.org4.sfiot.com","port": 14051}]},"version": "0"}}' config.json > modified_anchor_config.json

configtxlator proto_encode --input config.json --type common.Config --output config.pb

configtxlator proto_encode --input modified_anchor_config.json --type common.Config --output modified_anchor_config.pb

configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_anchor_config.pb --output anchor_update.pb

configtxlator proto_decode --input anchor_update.pb --type common.ConfigUpdate | jq . > anchor_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL_NAME'", "type":2}},"data":{"config_update":'$(cat anchor_update.json)'}}}' | jq . > anchor_update_in_envelope.json

configtxlator proto_encode --input anchor_update_in_envelope.json --type common.Envelope --output anchor_update_in_envelope.pb

peer channel update -f anchor_update_in_envelope.pb -c $CHANNEL_NAME -o orderer.sfiot.com:7050 --tls --cafile $ORDERER_CA

echo
echo "===================== Successfully Update Org4 Anchor Peer===================== "
echo

exit 0
