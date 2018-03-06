pragma solidity ^0.4.20;

contract Arithmetic {
    
    address private owner;

    function Arithmetic() public {
        owner = msg.sender;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function add(uint256 x, uint256 y) public pure returns(uint256) {
        return x + y;
    }

}