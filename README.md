# Edge-based Blockchain Design in SFIOT Project (Smart Gateway)

> Including blockchain design and configures using <a href="https://github.com/hyperledger/fabric" target="_blank">`Hyperledger Fabric`</a> divided on computer and raspberry pi 4


## 🔨Prerequisites

- <a href="https://golang.org/" target="_blank">`Go (v1.11.0 or later)`</a>
- <a href="https://docs.docker.com/get-docker/">`Docker(v18.03 or later)`</a>
- <a href="https://docs.docker.com/compose/" target="_blank">`Docker Compose (v1.14.0 or later)`</a>

> Tips
> - For AMD 64-bit architectre, get the docker images from
<a href="https://hub.docker.com/u/hyperledger" target="_blank">`https://hub.docker.com/u/hyperledger`</a> (v1.4.1 in this project)
> - For ARM(AArch64) 64-bit architectre get the docker images from one of below (and thank all of them :D)
<a href="https://hub.docker.com/u/zakialam" target="_blank">`https://hub.docker.com/u/zakialam`</a>
<a href="https://hub.docker.com/u/ptunstad" target="_blank">`https://hub.docker.com/u/ptunstad`</a>

---

## ✅Architecture

### Master
- `Consensus` (etcdraft)
- `Organizations` (Org1 to Org3)
- `Orderers` (Orderer to Orderer5)
- `Peers` (Peer0 and Peer1 for every org)
<img src="https://github.com/weishancc/SFIOT_blockchain/blob/master/master_arch.PNG" width="560" length="900"> 

### Org1_node
- `Organizations` (Org1)
- `Orderers` (Orderer to Orderer3)
- `Peers` (peer0.org1.sfiot.com / peer1.org1.sfiot.com)
- `Couchdbs` (couchdb0 / couchdb1)

### Org2_node
- `Organizations` (Org2)
- `Orderers` (Orderer4 to Orderer5)
- `Peers` (peer0.org2.sfiot.com / peer1.org2.sfiot.com)

---

## 🏃Running and Testing
> If divided, run Build Swarm Network and Build, Delete BC Network on every machine 

### Build Swarm Network 
- Step 1 (on Machine1)
```console
$ docker swarm init --advertise-addr <host-1 ip address>
$ docker swarm join-token manager
```
- Step 2 (on Machine2)
```console
$ <output from join-token manager> --advertise-addr <host n ip>
```
- Step 3 (on Machine3)
```console
$ docker network create --attachable --driver overlay sfiot-network
```

### Build BC Network 
```console
$ cd first-network
$ export OTHER_PATH="your-another-machine host and project's path", for example: user@X.X.X.X:~/first-network (only on Machine1)
$ ./build_network.sh
```

### Delete BC Network
```console
$ cd first-network
$ ./delete_network.sh
```
