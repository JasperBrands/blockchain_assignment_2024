pragma solidity ^0.8.0;

import "./AntFactory.sol";
import "./victoryToken.sol";

contract AntBattle is AntFactory {
    uint randNonce = 0;
    uint attackVictoryProbability = 50;

    // Define species advantages (if SpeciesA attacks SpeciesB, etc.)
    mapping(uint => mapping(uint => uint)) speciesAdvantages;

    constructor() {
        // Initialize species advantages (you can adjust these values as needed)
        speciesAdvantages[Species.FireAnt][Species.BlackCrazyAnt] = 20; // FireAnt has a 20% advantage against BlackCrazyAnt
        speciesAdvantages[Species.BlackCrazyAnt][Species.CarpenterAnt] = 20; // BlackCrazyAnt has a 20% advantage against CarpenterAnt
        speciesAdvantages[Species.CarpenterAnt][Species.FireAnt] = 20; // CarpenterAnt has a 20% advantage against FireAnt
        victoryToken = VictoryToken(_victoryTokenAddress);
    }

    function randMod(uint _modulus) internal returns(uint) {
        randNonce = randNonce + 1;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function getAntOwner(uint _antId) internal view returns (address) {
        return antToOwner[_antId];
    }

    function attack(uint _antId, uint _targetId) external {
        require(msg.sender == antToOwner[_antId], "You can only attack with your own ant");

        Ant storage myAnt = ants[_antId];
        Ant storage enemyAnt = ants[_targetId];

        uint rand = randMod(100);

        Species myAntSpecies = myAnt.species;
        Species enemyAntSpecies = enemyAnt.species;

        uint speciesAdvantage = speciesAdvantages[myAntSpecies][enemyAntSpecies];

        // Calculate final attack probability
        uint finalAttackProbability = attackVictoryProbability;
        if (speciesAdvantage > 0) {
            finalAttackProbability += speciesAdvantage; // Apply species advantage directly
        }

        if (rand <= finalAttackProbability) {
            myAnt.winCount++;
            myAnt.dna += enemyAnt.dna / 10; // You can modify this logic as needed
            enemyAnt.lossCount++;

            //give victory tokens to the winner 
            victoryToken._mint(msg.sender, 10 * 10 ** uint(victoryToken.decimals()));
        } else {
            myAnt.lossCount++;
            enemyAnt.winCount++;

            //give victory tokens to the winner
            address enemyAntOwner = getAntOwner(_enemyAntId); // You need to implement this function
            victoryToken._mint(enemyAntOwner, 10 * 10 ** uint(victoryToken.decimals()));
        }
    }
}