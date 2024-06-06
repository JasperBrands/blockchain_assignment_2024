// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";
import "./antbattle.sol";

contract AntToken is AntBattle {
  constructor(address _victoryTokenAddress) AntBattle(_victoryTokenAddress) {
  }

  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  // event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  // function balanceOf(address _owner) external view virtual returns (uint256);
  // function ownerOf(uint256 _tokenId) external view virtual returns (address);
  // function transferFrom(address _from, address _to, uint256 _tokenId) external payable virtual;
  // function approve(address _approved, uint256 _tokenId) external payable virtual;

  mapping (uint => address) antApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerAntCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return antToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    // Increase ant count for the new owner and decrease for the previous owner
    ownerAntCount[_to]++;
    ownerAntCount[_from]--;

    antToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
}

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (antToOwner[_tokenId] == msg.sender || antApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  // function approve(address _approved, uint256 _tokenId) external payable override onlyOwnerOf(_tokenId) {
  //   antApprovals[_tokenId] = _approved;
  //   emit Approval(msg.sender, _approved, _tokenId);
  // }
}
