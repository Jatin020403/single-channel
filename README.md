# FabricNetwork-2.x

## Network Topology

Three Orgs(Peer Orgs)

    - Each Org have 2 peers 
    - Each peer is capable of independently nedorsing a transaction
    - Each Peer has Current State database as couch db

One Orderer Org

    - Three Orderers
    - One Certificate Authority

## Start the network:

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

## Stop the network

   ```sh
   cd artifacts/
   docker-compose down
   ```
