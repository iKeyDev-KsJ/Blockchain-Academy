pragma solidity ^0.4.20;

contract Arithmetic {
    
    address private owner;

    function Arithmetic() public {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }

    function addOne(uint256 x, uint256 y) public view isOwner() returns(uint256) {
        return x + y;
    }

}