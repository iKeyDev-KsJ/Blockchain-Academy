pragma solidity ^0.4.20;

contract ArithmeticAbstract {
    function add(uint256 x, uint256 y) public pure returns(uint256);
}

contract Arithmetic is ArithmeticAbstract {

    address private owner;

    function Arithmetic() public {
        owner = msg.sender;
    }

    function add(uint256 x, uint256 y) public pure returns(uint256) {
        return x + y;
    }

}