pragma solidity ^0.4.21;

contract Example {
    
    address private owner;

    function Example() public {
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