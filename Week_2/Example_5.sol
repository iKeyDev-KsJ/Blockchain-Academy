pragma solidity ^0.4.21;

contract ExampleAbstract {
    function add(uint256 x, uint256 y) public pure returns(uint256);
}

contract Example is ExampleAbstract {

    address private owner;

    function Example() public {
        owner = msg.sender;
    }

    function add(uint256 x, uint256 y) public pure returns(uint256) {
        return x + y;
    }

}