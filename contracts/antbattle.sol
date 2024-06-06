pragma solidity ^0.8.0;

import "./antfactory.sol";
import "./victoryToken.sol";

contract AntBattle is AntFactory {
    constructor(address _victoryTokenAddress) AntFactory(_victoryTokenAddress) {
        // Initialize species advantages (you can adjust these values as needed)
        speciesAdvantages[uint(Species.FireAnt)][uint(Species.BlackCrazyAnt)] = 20; // FireAnt has a 20% advantage against BlackCrazyAnt
        speciesAdvantages[uint(Species.BlackCrazyAnt)][uint(Species.CarpenterAnt)] = 20; // BlackCrazyAnt has a 20% advantage against CarpenterAnt
        speciesAdvantages[uint(Species.CarpenterAnt)][uint(Species.FireAnt)] = 20; // CarpenterAnt has a 20% advantage against FireAnt 
        victoryToken = VictoryToken(_victoryTokenAddress); // Corrected assignment
    }

    uint randNonce = 0;
    uint attackVictoryProbability = 50;

    // Define species advantages (if SpeciesA attacks SpeciesB, etc.)
    mapping(uint => mapping(uint => uint)) speciesAdvantages;

    // constructor(address _victoryTokenAddress) {
    //     // Initialize species advantages (you can adjust these values as needed)
    //     speciesAdvantages[uint(Species.FireAnt)][uint(Species.BlackCrazyAnt)] = 20; // FireAnt has a 20% advantage against BlackCrazyAnt
    //     speciesAdvantages[uint(Species.BlackCrazyAnt)][uint(Species.CarpenterAnt)] = 20; // BlackCrazyAnt has a 20% advantage against CarpenterAnt
    //     speciesAdvantages[uint(Species.CarpenterAnt)][uint(Species.FireAnt)] = 20; // CarpenterAnt has a 20% advantage against FireAnt 
    //     victoryToken = VictoryToken(_victoryTokenAddress); // Corrected assignment
    // }

    function randMod(uint _modulus) internal returns(uint) {
        randNonce = randNonce + 1;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function getAntOwner(uint _antId) internal view returns (address) {
        return antToOwner[_antId];
    }

    function getAntsByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerAntCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < ants.length; i++) {
            if (antToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function attack(uint _antId, uint _targetId) external {
        require(msg.sender == antToOwner[_antId], "You can only attack with your own ant");

        Ant storage myAnt = ants[_antId];
        Ant storage enemyAnt = ants[_targetId];

        uint rand = randMod(100);

        Species myAntSpecies = myAnt.species;
        Species enemyAntSpecies = enemyAnt.species;

        // uint speciesAdvantage = speciesAdvantages[myAntSpecies][enemyAntSpecies];
        uint speciesAdvantage = speciesAdvantages[uint(myAntSpecies)][uint(enemyAntSpecies)];

        // Calculate final attack probability
        uint finalAttackProbability = attackVictoryProbability;
        
        if (speciesAdvantage > 0) {
            finalAttackProbability += uint(speciesAdvantage); // Apply species advantage directly
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
            address enemyAntOwner = getAntOwner(_targetId); // Corrected usage
            victoryToken._mint(enemyAntOwner, 10 * 10 ** uint(victoryToken.decimals()));
        }
    }
}