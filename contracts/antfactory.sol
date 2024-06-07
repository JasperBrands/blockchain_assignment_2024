// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./victoryToken.sol";

contract AntFactory {
    event NewAnt(uint antId, string name, uint dna, Species species, uint winCount, uint lossCount);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint speciesModulus = 3;
    uint public antPrice = 3;

    VictoryToken public victoryToken;

    enum Species { FireAnt, BlackCrazyAnt, CarpenterAnt }

    struct Ant {
        string name;
        uint dna;
        Species species;
        uint winCount;
        uint lossCount;
    }

    Ant[] public ants;

    function getAnts() public view returns (Ant[] memory) {
        return ants;
    }

    mapping (uint => address) public antToOwner;
    mapping (address => uint) public ownerAntCount;
    mapping (uint => uint) public dnaToId;

    constructor(address _victoryTokenAddress) {
        victoryToken = VictoryToken(_victoryTokenAddress);
    }

    function _createAnt(string memory _name, uint _dna, Species _species, uint _winCount, uint _lossCount) public {
        ants.push(Ant(_name, _dna, _species, _winCount, _lossCount));
        uint id = ants.length - 1;
        antToOwner[id] = msg.sender;
        ownerAntCount[msg.sender]++;
        dnaToId[_dna] = id;
        emit NewAnt(id, _name, _dna, _species, _winCount, _lossCount);
    }

    function _generateRandomDna(string memory _str) public view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function _generateRandomSpecies() public view returns (Species) {
        uint randSpecies = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % speciesModulus;
        return Species(randSpecies);
    }

    function createRandomAnt(string memory _name) public {
        if (ownerAntCount[msg.sender] == 0) {
            uint randDna = _generateRandomDna(_name);
            randDna = randDna - randDna % 100;
            Species randSpecies = _generateRandomSpecies();
            _createAnt(_name, randDna, randSpecies, 0, 0);
        }else {
            revert("You already own an ant. Use buyAntByChoice to buy more.");
        }
    }

    function getAntId(uint _dna) public view returns (uint) {
        return dnaToId[_dna];
    }

    function buyAntByChoice(string memory _name, Species _species) public {
        require(ownerAntCount[msg.sender] > 0, "You must own at least one ant to buy more.");
        // require(victoryToken.getTokenCount(msg.sender) >= antPrice, "Insufficient VictoryTokens.");

        // Transfer VictoryTokens from the buyer to this contract
        // require(victoryToken.transfer(address(this), antPrice), "Token transfer failed.");

        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createAnt(_name, randDna, _species, 0, 0);
    }

    function getAntOwner(uint _antId) public view returns (address) {
        return antToOwner[_antId];
    }

    function getAntsByOwner(address _owner) public view returns (Ant[] memory) {
        uint ownerCount = ownerAntCount[_owner];
        Ant[] memory result = new Ant[](ownerCount);
        uint counter = 0;
        for (uint i = 0; i < ants.length; i++) {
            if (antToOwner[i] == _owner) {
                result[counter] = ants[i];
                counter++;
            }
        }
        return result;
    }
}
