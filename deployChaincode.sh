#!/bin/bash

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER1_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export PEER1_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
export PEER1_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=exchange

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

setGlobalsForPeer0Org1() {
    export CHANNEL_NAME=exchange
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Org1() {
    export CHANNEL_NAME=exchange
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7061
}

setGlobalsForPeer0Org2() {
    export CHANNEL_NAME=exchange
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

setGlobalsForPeer1Org2() {
    export CHANNEL_NAME=exchange
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9061
}

setGlobalsForPeer0Org3() {
    export CHANNEL_NAME=exchange
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
}

setGlobalsForPeer1Org3() {
    export CHANNEL_NAME=exchange
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11061
}

presetup() {
    echo Vendoring Go dependencies for 1...
    pushd ./artifacts/src/github.com/fabcar/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies for 1
}
# presetup

setGlobalsForChaincode() {
    CC_RUNTIME_LANGUAGE="golang"
    VERSION="1"
    CC_SRC_PATH="./artifacts/src/github.com/fabcar/go"
    CC_NAME="fabcar"
}

packageChaincodeIOT() {
    setGlobalsForChaincode
    setGlobalsForPeer0Org1
    rm -rf ${CC_NAME}.tar.gz
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.org1 ===================== "
}

packageChaincode() {
    packageChaincodeIOT
}
# packageChaincode

installChaincodeIOT() {
    setGlobalsForChaincode

    setGlobalsForPeer0Org1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org1 ===================== "

    setGlobalsForPeer1Org1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.org1 ===================== "

    setGlobalsForPeer0Org2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org2 ===================== "

    setGlobalsForPeer1Org2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.org2 ===================== "

    setGlobalsForPeer0Org3
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org3 ===================== "

    setGlobalsForPeer1Org3
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.org3 ===================== "
}

installChaincode() {
    installChaincodeIOT
}

# installChaincode

queryInstalled() {
    setGlobalsForChaincode
    setGlobalsForPeer0Org1
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel IOT ===================== "
}

# queryInstalled

approveForMyOrg1() {
    setGlobalsForPeer0Org1
    setGlobalsForChaincode
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --sequence ${VERSION} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --init-required
    # set +x

    echo "===================== IOT chaincode approved from org 1 ===================== "
}

getBlock() {
    setGlobalsForPeer0Org1
    # peer channel fetch 10 -c mychannel -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com --tls \
    #     --cafile $ORDERER_CA

    peer channel getinfo -c mychannel -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA
}

# getBlock

# approveForMyOrg1

# --signature-policy "OR ('Org1MSP.member')"
# --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA
# --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA
#--channel-config-policy Channel/Application/Admins
# --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer')"

# --collections-config ./artifacts/private-data/collections_config.json \
# --signature-policy "OR('Org1MSP.member','Org2MSP.member')" \
approveForMyOrg2() {
    setGlobalsForPeer0Org2
    setGlobalsForChaincode

    # peer lifecycle chaincode approveformyorg -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com --tls \
    #     --sequence ${VERSION} \
    #     --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
    #     --package-id ${PACKAGE_ID} --init-required

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --sequence ${VERSION} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --init-required

    echo "===================== IOT chaincode approved from org 2 ===================== "

}

approveForMyOrg3() {
    setGlobalsForPeer0Org3
    setGlobalsForChaincode

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --sequence ${VERSION} \
        --version ${VERSION} --package-id ${PACKAGE_ID} \
        --init-required

    echo "===================== IOT chaincode approved from org 3 ===================== "
}

# approveForMyOrg2

# checkCommitReadyness() {

#     setGlobalsForPeer0Org1
#     peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
#         --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
#         --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
#     echo "===================== checking commit readyness from org 1 ===================== "
# }

approveForOrgs() {
    approveForMyOrg1
    approveForMyOrg2
    approveForMyOrg3
}

checkCommitReadyness() {
    setGlobalsForPeer0Org1
    setGlobalsForChaincode
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from IOT org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0Org1
    setGlobalsForChaincode
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0Org1
    setGlobalsForChaincode
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0Org1
    setGlobalsForChaincode
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --isInit -c '{"Args":[]}'

}

# chaincodeInvokeInit

chaincodeInitLedger() {
    setGlobalsForPeer0Org1
    setGlobalsForChaincode

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 \
        --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function":"initLedger","Args":[]}'
}

chaincodeInvoke() {
    setGlobalsForChaincode

    setGlobalsForPeer0Org1
    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        -c '{"function":"initLedger","Args":[]}'

    ## Create Car
    setGlobalsForPeer1Org1
    setGlobalsForChaincode
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7061 \
        --tlsRootCertFiles $PEER1_ORG1_CA \
        -c '{"function": "createData","Args":["P0O1", "Damn the torpedoes, Full speed ahead!!"]}' # --peerAddresses localhost:9051 \
    # --tlsRootCertFiles $PEER0_ORG2_CA \

    # ## Create Car
    # setGlobalsForPeer1Org2
    # setGlobalsForChaincode
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:9061 \
    #     --tlsRootCertFiles $PEER1_ORG2_CA \
    #     -c '{"function": "createData","Args":["P1O2", "Either I will come back after hoisting the tricolour or I come wrapped in it!!"]}'

    setGlobalsForPeer1Org2
    setGlobalsForChaincode
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:9061 \
        --tlsRootCertFiles $PEER1_ORG2_CA \
        -c '{"function": "createData","Args":["P1O2", "NumaNuma"]}'
    # --peerAddresses localhost:7051 \
    # --tlsRootCertFiles $PEER0_ORG1_CA \
}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForChaincode
    setGlobalsForPeer1Org2

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryData","Args":["P0O1"]}'
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryData","Args":["P1O1"]}'
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryData","Args":["P0O2"]}'
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryData","Args":["P1O2"]}'
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryData","Args":["P0O3"]}'
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryData","Args":["P1O3"]}'
    # Query all cars

    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function":"queryAllCars","Args":[]}'

    # Query Car by Id
    #'{"Args":["GetSampleData","Key1"]}'

}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
presetup
packageChaincode

installChaincode
queryInstalled
approveForOrgs
checkCommitReadyness
commitChaincodeDefination
queryCommitted
chaincodeInvokeInit
sleep 1
## chaincodeInitLedger
chaincodeQuery
sleep 1
chaincodeInvoke
sleep 2
chaincodeQuery
