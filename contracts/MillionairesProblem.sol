pragma solidity ^0.4.17; 

// Import Enigma contract
import "./Enigma.sol";

contract MillionairesProblem {
	// Millionaire struct containing name and netWorth properties
	struct Millionaire {
		bytes32 name; 
		bytes32 netWorth; 
	}

	uint public numMillionaires; 
	Millionaire[] public millionaires; 
	address public richestMillionaire; 
	address public owner;
	Enigma public enigma;

	constructor(address _enigmaAddress, address _owner) public {
		owner = _owner; 
		enigma = Enigma(_enigmaAddress);
	}

	// Modifier to ensure only enigma contract can call function
	modifier onlyEnigma() {
        require(msg.sender == address(enigma));
        _;
    }

    // Function to send millionaire's name and encrypted net worth to contract storage
	function stateNetWorth(bytes32 _name, bytes32 _netWorth) public {
		Millionaire storage currentMillionaire = millionaires[numMillionaires]; 
		currentMillionaire.name = _name; 
		currentMillionaire.netWorth = _netWorth; 
		numMillionaires++; 
	}

	// Function to return tuple of lists containing millionaire names and encrypted net worths
	function getMillionaires() public view returns (bytes32[], bytes32[]) {
		bytes32[] memory names = new bytes32[](numMillionaires); 
		bytes32[] memory netWorths = new bytes32[](numMillionaires); 
		for (uint i = 0; i < numMillionaires; i++) {
			Millionaire memory currentMillionaire = millionaires[i]; 
			names[i] = currentMillionaire.name; 
			netWorths[i] = currentMillionaire.netWorth; 
		}
		return (names, netWorths); 
	}

	function getRichestName() public view returns (address) {
		return richestMillionaire; 
	}
	
	// CALLABLE FUNCTION run in SGX to decipher encrypted net worths to determine richest millionaire
	function computeRichest(address[] _names, uint[] _netWorths) public pure returns (address) {
		if (_netWorths[1] >= _netWorths[0]) {
			return _names[1]; 
		}
		return _names[0]; 
	}

	// CALLBACK FUNCTION to change contract state tracking richest millionaire's name
	function setRichestName(address _name) public onlyEnigma() {
		richestMillionaire = _name; 
	}
}