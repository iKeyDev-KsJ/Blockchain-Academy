pragma solidity ^0.4.20;

contract Arithmetic {
    
    address private owner;

    function Arithmetic() public {
        owner = msg.sender;
    }

    function addOne(uint256 x, uint256 y) public view returns(uint256) {
        require(owner == msg.sender);
        return x + y;
    }

    function addTwo(uint256 x, uint256 y) public view returns(uint256) {
        assert(owner == msg.sender);
        return x + y;
    }

    function addThree(uint256 x, uint256 y) public view returns(uint256) {
        if (owner == msg.sender) {revert();}
        return x + y;
    }

}