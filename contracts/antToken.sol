// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./AntFactory.sol";

contract AntToken is ERC721URIStorage, Ownable, AntFactory {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Ant Token", "ANT") {}

    function mintItem(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    function createRandomAnt(string memory _name, string memory tokenURI) public onlyOwner {
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        Species randSpecies = _generateRandomSpecies();
        _createAnt(_name, randDna, randSpecies, 0, 0);

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
    }
}
