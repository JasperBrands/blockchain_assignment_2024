pragma solidity ^0.8.0;

contract AntFactory {

    event NewAnt(uint antId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Ant {
        string name;
        uint dna;
    }

    Ant[] public ants;

    mapping (uint => address) public antToOwner;
    mapping (address => uint) ownerAntCount;

    function _createAnt(string memory _name, uint _dna) internal {
        ants.push(Ant(_name, _dna));
        uint id = ants.length - 1;
        antToOwner[id] = msg.sender;
        ownerAntCount[msg.sender]++;
        emit NewAnt(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomAnt(string memory _name) public {
        require(ownerAntCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createAnt(_name, randDna);
    }
}
