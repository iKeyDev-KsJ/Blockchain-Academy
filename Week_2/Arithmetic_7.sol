pragma solidity ^0.4.20;

contract ArithmeticAbstract {
    function _addOne(uint256 x, uint256 y) external pure returns(uint256) {
        return x + y;
    }
    function _addTwo(uint256 x, uint256 y) public pure returns(uint256) {
        return x + y;
    }
}

contract Arithmetic is ArithmeticAbstract {

    address private owner;
    ArithmeticAbstract private arithmeticAbstract;

    function Arithmetic() public {
        owner = msg.sender;
        arithmeticAbstract = new ArithmeticAbstract();
    }

    function addOne(uint256 x, uint256 y) public view returns(uint256) {
        return arithmeticAbstract._addOne(x, y);
    }

    function addTwo(uint256 x, uint256 y) public pure returns(uint256) {
        return _addTwo(x, y);
    }

}