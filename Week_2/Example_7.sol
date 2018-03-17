pragma solidity ^0.4.21;

contract ExampleAbstract {
    function _addOne(uint256 x, uint256 y) external pure returns(uint256) {
        return x + y;
    }
    function _addTwo(uint256 x, uint256 y) public pure returns(uint256) {
        return x + y;
    }
}

contract Example is ExampleAbstract {

    address private owner;
    ExampleAbstract private exampleAbstract;

    function Example() public {
        owner = msg.sender;
        exampleAbstract = new ExampleAbstract();
    }

    function addOne(uint256 x, uint256 y) public view returns(uint256) {
        return exampleAbstract._addOne(x, y);
    }

    function addTwo(uint256 x, uint256 y) public pure returns(uint256) {
        return _addTwo(x, y);
    }

}