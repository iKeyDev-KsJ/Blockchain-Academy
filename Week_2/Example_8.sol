pragma solidity ^0.4.21;

library ExampleLibrary {
    function _addOne(uint256 x, uint256 y) internal pure returns(uint256) {
        return x + y;
    }
}

contract Example {
    
    using ExampleLibrary for *;
    address private owner;

    function Example() public {
        owner = msg.sender;
    }

    function addOne(uint256 x, uint256 y) public pure returns(uint256) {
        return ExampleLibrary._addOne(x, y);
    }

}