pragma solidity ^0.4.21;

contract Example {
    
    address private owner;

    function Example() public {
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