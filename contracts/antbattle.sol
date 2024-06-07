pragma solidity ^0.8.0;

import "./antfactory.sol";
import "./victoryToken.sol";

contract AntBattle is AntFactory {
    constructor(address _victoryTokenAddress) AntFactory(_victoryTokenAddress) {
        speciesAdvantages[uint(Species.FireAnt)][uint(Species.BlackCrazyAnt)] = 20; // FireAnt has a 20% advantage against BlackCrazyAnt
        speciesAdvantages[uint(Species.BlackCrazyAnt)][uint(Species.CarpenterAnt)] = 20; // BlackCrazyAnt has a 20% advantage against CarpenterAnt
        speciesAdvantages[uint(Species.CarpenterAnt)][uint(Species.FireAnt)] = 20; // CarpenterAnt has a 20% advantage against FireAnt 
        victoryToken = VictoryToken(_victoryTokenAddress);
    }

    uint randNonce = 0;
    uint attackVictoryProbability = 50;
    mapping(uint => mapping(uint => uint)) speciesAdvantages;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce = randNonce + 1;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _antDna, uint _targetDna) public {
        uint _antId = getAntId(_antDna);
        uint _targetId = getAntId(_targetDna);

        // require(msg.sender == getAntOwner(_antId), "You can only attack with your own ant");

        Ant storage myAnt = ants[_antId];
        Ant storage enemyAnt = ants[_targetId];

        uint rand = randMod(100);

        Species myAntSpecies = myAnt.species;
        Species enemyAntSpecies = enemyAnt.species;

        uint speciesAdvantage = speciesAdvantages[uint(myAntSpecies)][uint(enemyAntSpecies)];

        // Calculate final attack probability
        uint finalAttackProbability = attackVictoryProbability;
        
        if (speciesAdvantage > 0) {
            finalAttackProbability += uint(speciesAdvantage);
        }

        if (rand <= finalAttackProbability) {
            myAnt.winCount++;
            myAnt.dna += enemyAnt.dna / 10; // You can modify this logic as needed
            enemyAnt.lossCount++;

            //give victory tokens to the winner 
            // victoryToken._mintVictoryTokens(msg.sender, 1);
        } else {
            myAnt.lossCount++;
            enemyAnt.winCount++;

            //give victory tokens to the winner
            // address enemyAntOwner = getAntOwner(_targetId);
            // victoryToken._mintVictoryTokens(enemyAntOwner, 1);
        }
    }
}