// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./antfactory.sol";

contract AntToken is ERC721URIStorage, Ownable {
    AntFactory private antFactory; // Instance of AntFactory contract
    uint256 private _tokenIdTracker;

    constructor(address antFactoryAddress, address initialOwner) ERC721("Ant Token", "ANT") Ownable(initialOwner) {
        antFactory = AntFactory(antFactoryAddress); // Initialize AntFactory contract instance
    }

    function mintItem(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 newItemId = _getNextTokenId();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    function createRandomAnt(string memory _name, string memory tokenURI) public onlyOwner {
        uint randDna = antFactory._generateRandomDna(_name); // Call function from AntFactory contract
        randDna = randDna - randDna % 100;
        AntFactory.Species randSpecies = antFactory._generateRandomSpecies(); // Call function from AntFactory contract
        antFactory._createAnt(_name, randDna, randSpecies, 0, 0); // Call function from AntFactory contract

        uint256 newItemId = _getNextTokenId();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
    }

    function _getNextTokenId() private returns (uint256) {
        _tokenIdTracker++;
        return _tokenIdTracker;
    }
}
