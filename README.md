# FabricNetwork-2.x

Network Topology

Three Orgs(Peer Orgs)

    - Each Org have one peer(Each Endorsing Peer)
    - Each Org have separate Certificate Authority
    - Each Peer has Current State database as couch db

One Orderer Org

    - Three Orderers
    - One Certificate Authority

Steps:

1. Clone the repo
2. Create artifacts
   ```sh
   cd artifacts/channel
   ./create-artifacts.sh
   ```
3. Make the nodes
   ```sh
   cd ..
   docker-compose up -d
   ```
4. Make the channels
   ```sh
   cd ..
   ./createChannel.sh
   ```

5. Deploy Chaincode
   ```sh
   ./deployChaincode.sh
   ```
