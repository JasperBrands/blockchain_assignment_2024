pragma solidity ^0.8.0;

import "./AntFactory.sol";

contract AntBattle is AntFactory {
    uint randNonce = 0;
    uint attackVictoryProbability = 50;

    // Define species advantages (if SpeciesA attacks SpeciesB, etc.)
    mapping(uint => mapping(uint => uint)) speciesAdvantages;

    constructor() {
        // Initialize species advantages (you can adjust these values as needed)
        speciesAdvantages[uint(Species.FireAnt)][uint(Species.BlackCrazyAnt)] = 20; // FireAnt has a 20% advantage against BlackCrazyAnt
        speciesAdvantages[uint(Species.BlackCrazyAnt)][uint(Species.CarpenterAnt)] = 20; // BlackCrazyAnt has a 20% advantage against CarpenterAnt
        speciesAdvantages[uint(Species.CarpenterAnt)][uint(Species.FireAnt)] = 20; // CarpenterAnt has a 20% advantage against FireAnt
    }

    function randMod(uint _modulus) internal returns(uint) {
        randNonce = randNonce + 1;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _antId, uint _targetId) external {
        require(msg.sender == antToOwner[_antId], "You can only attack with your own ant");

        Ant storage myAnt = ants[_antId];
        Ant storage enemyAnt = ants[_targetId];

        uint rand = randMod(100);

        // Convert species enum to uint for indexing the advantage mapping
        uint myAntSpeciesIndex = uint(myAnt.species);
        uint enemyAntSpeciesIndex = uint(enemyAnt.species);

        uint speciesAdvantage = speciesAdvantages[myAntSpeciesIndex][enemyAntSpeciesIndex];

        // Calculate final attack probability
        uint finalAttackProbability = attackVictoryProbability;
        if (speciesAdvantage > 0) {
            finalAttackProbability += speciesAdvantage; // Apply species advantage directly
        }

        if (rand <= finalAttackProbability) {
            myAnt.winCount++;
            myAnt.dna += enemyAnt.dna / 10; // You can modify this logic as needed
            enemyAnt.lossCount++;
        } else {
            myAnt.lossCount++;
            enemyAnt.winCount++;
        }
    }
}