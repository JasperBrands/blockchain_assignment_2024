pragma solidity ^0.8.0;

// • Define a token, for a means of exchange, which can be used to purchase battlefocused ERC721 tokens;
import "./erc721.sol";
import "./ownable.sol"; 

abstract contract ExchangeToken is ERC721, Ownable {
    string public name = "Exchange Token";
    string public symbol = "EXT";
}

// • Create a simple, yet functioning Web3JS front-end, for users to interact with the
// program (you are free to use any open source repositories for this);

// • Develop prudent documentation in a readme.md file, which explains the overarching
// structure, logic and functions of your application;

// • Submit a bug-free, functioning test application, which can be simulated in a testing
// environment with no errors;