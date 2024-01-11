package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	sc "github.com/hyperledger/fabric-protos-go/peer"
	"github.com/hyperledger/fabric/common/flogging"
)

// SmartContract Define the Smart Contract structure
type SmartContract struct {
}

type Data struct {
	Owner   string `json:"owner"`
	Message string `json:"message"`
}

// Init ;  Method for initializing smart contract
func (s *SmartContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

var logger = flogging.MustGetLogger("fabcar_cc")

func (s *SmartContract) queryData(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	dataAsBytes, _ := APIstub.GetState(args[0])
	return shim.Success(dataAsBytes)
}

func (s *SmartContract) initLedger(APIstub shim.ChaincodeStubInterface) sc.Response {
	data_arr := []Data{
		{Message: "1 message xyz", Owner: "P0O1"},
		{Message: "2 message xyz", Owner: "P1O1"},
		{Message: "3 message xyz", Owner: "P0O2"},
		{Message: "4 message xyz", Owner: "P1O2"},
		{Message: "5 message xyz", Owner: "P0O3"},
		{Message: "6 message xyz", Owner: "P1O3"},
	}

	for i := 0; i < len(data_arr); i += 1 {
		// randomIndex := rand.Intn(len(data_arr))
		dataAsBytes, err := json.Marshal(data_arr[i])
		APIstub.PutState(data_arr[i].Owner, dataAsBytes)

		if err != nil {
			return shim.Error(err.Error())

		}
	}

	return shim.Success(nil)
}

func (s *SmartContract) createData(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	var data = Data{Message: args[1], Owner: args[0]}

	dataAsBytes, _ := json.Marshal(data)
	APIstub.PutState(args[0], dataAsBytes)

	return shim.Success(dataAsBytes)
}

func (s *SmartContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	function, args := APIstub.GetFunctionAndParameters()
	logger.Infof("Function name is:  %d", function)
	logger.Infof("Args length is : %d", len(args))

	switch function {
	case "queryData":
		return s.queryData(APIstub, args)
	case "initLedger":
		return s.initLedger(APIstub)
	case "createData":
		return s.createData(APIstub, args)
	default:
		return shim.Error("Invalid Smart Contract function name.")
	}
}

func main() {

	// Create a new Smart Contract
	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
