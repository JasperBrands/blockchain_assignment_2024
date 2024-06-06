pragma solidity ^0.8.0;

contract VictoryToken {
    string public name = "Victory Token";
    string public symbol = "VCT";
    // uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);

    // function balanceOf(address _owner) external view returns (uint256) {
    //     return ownerAntCount[_owner];
    // }
    
    function _mint(address _to, uint256 _value) public {
        totalSupply += _value;
        balanceOf[_to] += _value;
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    //     require(_value <= balanceOf[_from], "Insufficient balance");
    //     require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
    //     balanceOf[_from] -= _value;
    //     balanceOf[_to] += _value;
    //     allowance[_from][msg.sender] -= _value;
    //     emit Transfer(_from, _to, _value);
    //     return true;
    // }
}
