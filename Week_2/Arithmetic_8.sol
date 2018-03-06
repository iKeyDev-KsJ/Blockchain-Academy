pragma solidity ^0.4.20;

library ArithmeticLibrary {
    function _addOne(uint256 x, uint256 y) internal pure returns(uint256) {
        return x + y;
    }
}

contract Arithmetic {
    
    using ArithmeticLibrary for *;
    address private owner;

    function Arithmetic() public {
        owner = msg.sender;
    }

    function addOne(uint256 x, uint256 y) public pure returns(uint256) {
        return ArithmeticLibrary._addOne(x, y);
    }

}