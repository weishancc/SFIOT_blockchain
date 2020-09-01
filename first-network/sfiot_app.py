import asyncio
import time
from hfc.fabric import Client
from argparse import ArgumentParser

# Add arguments
parser = ArgumentParser()
parser.add_argument("pos1", help="1st positional argument")
parser.add_argument("pos2", help="2nd positional argument")
args = parser.parse_args()

loop = asyncio.get_event_loop()

cli = Client(net_profile="./network.json")
org1_admin = cli.get_user('org1.sfiot.com', 'Admin')

# Make the client know there is a channel in the network
cli.new_channel('mychannel')

# Invoke a chaincode
# The response should be true if succeed
response_inv = loop.run_until_complete(cli.chaincode_invoke(
               requestor=org1_admin,
               channel_name='mychannel',
               peers=['peer0.org1.sfiot.com'],
               fcn=args.pos1,
               args=["E_1","12-02-05","N","200","01"],
               cc_name='sfiotcc',
               transient_map=None, # optional, for private data
               wait_for_event=True, 
               ))
print(response_inv)

# Sleep and then query
time.sleep(3)

# Query a chaincode
response_que = loop.run_until_complete(cli.chaincode_query(
               requestor=org1_admin,
               channel_name='mychannel',
               peers=['peer0.org1.sfiot.com'],
               fcn=args.pos2,
               args=[],
               cc_name='sfiotcc',
               ))
print(response_que)
