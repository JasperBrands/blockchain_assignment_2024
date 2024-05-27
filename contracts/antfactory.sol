// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AntFactory {
    event NewAnt(uint antId, string name, uint dna, Species species, uint winCount, uint lossCount);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint speciesModulus = 3;

    enum Species { FireAnt, BlackCrazyAnt, CarpenterAnt }

    struct Ant {
        string name;
        uint dna;
        Species species;
        uint winCount;
        uint lossCount;
    }

    Ant[] public ants;

    mapping (uint => address) public antToOwner;
    mapping (address => uint) ownerAntCount;

    function _createAnt(string memory _name, uint _dna, Species _species, uint _winCount, uint _lossCount) internal {
        ants.push(Ant(_name, _dna, _species, _winCount, _lossCount));
        uint id = ants.length - 1;
        antToOwner[id] = msg.sender;
        ownerAntCount[msg.sender]++;
        emit NewAnt(id, _name, _dna, _species, _winCount, _lossCount);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function _generateRandomSpecies() private view returns (Species) {
        uint randSpecies = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % speciesModulus;
        return Species(randSpecies);
    }

    function createRandomAnt(string memory _name) public {
        require(ownerAntCount[msg.sender] == 0, "Each address can only own one ant");
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        Species randSpecies = _generateRandomSpecies();
        _createAnt(_name, randDna, randSpecies, 0, 0);
    }
}
