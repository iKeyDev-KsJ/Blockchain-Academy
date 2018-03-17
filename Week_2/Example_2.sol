pragma solidity ^0.4.21;

contract Example {
    
    address private owner;

    function Example() public {
        owner = msg.sender;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function add(uint256 x, uint256 y) public pure returns(uint256) {
        return x + y;
    }

}