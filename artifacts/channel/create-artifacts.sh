#!/bin/bash

# Delete existing artifacts
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*
rm -rf ./crypto-config

#Generate Crypto artifactes for organizations
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/

# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "peerChannel"
EXCHANGE_CHANNEL="exchange"

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL -outputBlock ./genesis.block

# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$EXCHANGE_CHANNEL.tx -channelID $EXCHANGE_CHANNEL

# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$EXCHANGE_CHANNEL.tx -channelID $EXCHANGE_CHANNEL

# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$EXCHANGE_CHANNEL.tx -channelID $EXCHANGE_CHANNEL

# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$EXCHANGE_CHANNEL.tx -channelID $EXCHANGE_CHANNEL

echo "#######    Generating anchor peer update for Org1MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org1MSPanchors.tx -channelID $EXCHANGE_CHANNEL -asOrg Org1MSP

echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org2MSPanchors.tx -channelID $EXCHANGE_CHANNEL -asOrg Org2MSP

echo "#######    Generating anchor peer update for Org3MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org3MSPanchors.tx -channelID $EXCHANGE_CHANNEL -asOrg Org3MSP
