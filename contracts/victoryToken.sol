pragma solidity ^0.8.0;

// • Define a token, for a means of exchange, which can be used as a ‘victory currency’
// when a battle commences;

contract VictoryToken {
    string public name = "Victory Token";
    string public symbol = "VCT";
    // uint256 public totalSupply = 76_000_000; // 76 million tokens with no decimal places
    mapping(address => uint256) public balanceOf;
    
    // constructor() {
    //     balanceOf[msg.sender] = totalSupply;
    // }
}