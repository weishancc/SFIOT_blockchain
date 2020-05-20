#server for BC container
import json
import time
import os
import threading as th

from socket_lib.socket_listen_for_inner import listen_inner_network_END

# our_address = "127.0.0.1"	#our ip address.
# our_PORT = 1234						#our Port number.
METER_AMOUNT = 200

def BC_receiver_run(flag, port):
	buf = []  #define a buffer for receive data.

	times = 0;		#calculate how many of data.

	total_data =[]			#storage total receive data(200).
	total_data_json =[]			#transform data format to json.
	print("BC thread start!")
	print(port)

	while True:
		total_data = listen_inner_network_END(port)
		if "ESC" in total_data[0]:
			print("Stoped!")
			break			#quit thread in a safe method.
		#********************************************************************************************   
		total_data_json.clear()

		#deal with datas to BC cmd format
		for i in range(0,len(total_data)):
			total_data_split = total_data[i].split(';')		#split string

			total_data_json.append('\'{\"Args\":[\"save_data\",\"'+ total_data_split[0] +'\",\"'+ total_data_split[1] +'\",\"'+ total_data_split[2] +'\",\"'+ total_data_split[3] +'\",\"'+total_data_split[4]+'\"]}\'')
			#print(total_data_json[i])

			#-----------finish transfrom---------------------
			total_data_split.clear()		#clear buffer 
		
		total_data.clear()			#clear buffer 	
		#print(len(total_data_json)

		#---------------do BC transaction----------------------------
		record_file = open("BC_record.txt","w+")
		
		#test the performance of transactions with different number of threads
		threads = []
		for i in range(1):
			threads.append(th.Thread(target = store_BC, args = (total_data_json, i)))
			threads[i].start()
		
		for thread in threads:
			thread.join()
			
		#print("total time : " + str(time.time() - t0))
		print("record finished!")
		#------------------------------------------------------------
#=========BC store format=============================================================
"""
	'{"Args":["save_data","H-200","2019-12-05,00:00:00","N","","GateWayID"]}'   #the format of BC cmd 
"""
#-------------------------------------------------------------
"""
	'{"Args":["save_data","H-200","2019-12-05,00:00:00","N","60.5","GateWayID"]}'   #the format of BC cmd 
"""
#=====================================================================================
def store_BC(total_data_json, i):
		count = 0
		for j in range(0,len(total_data_json)):
			#record_file.write(total_data_json[i]+"\n")
			os.system('peer chaincode invoke -o orderer.sfiot.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/sfiot.com/orderers/orderer.sfiot.com/msp/tlscacerts/tlsca.sfiot.com-cert.pem -C mychannel -n sfiotcc --peerAddresses peer0.org1.sfiot.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.sfiot.com/peers/peer0.org1.sfiot.com/tls/ca.crt -c ' + total_data_json[j])
			count += 1

			#record_file.close()
			#print(j)
			#print()
		print('Thread[' + str(i) + ']: ' + str(count) + ' transactions.' + '\n')
