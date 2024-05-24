// • Create a simple, yet functioning Web3JS front-end, for users to interact with the
// program (you are free to use any open source repositories for this);

// • Develop prudent documentation in a readme.md file, which explains the overarching
// structure, logic and functions of your application;

// • Submit a bug-free, functioning test application, which can be simulated in a testing
// environment with no errors;

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ExchangeToken is ERC721URIStorage, Ownable {
    string public name = "Exchange Token";
    string public symbol = "EXT";

    function mintItem(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}