pragma solidity ^0.4.20;

contract Arithmetic {

    address private _owner_1;
    address internal _owner_2;
    address public _owner_3;

    function Arithmetic() public {
        _owner_1 = msg.sender;
        _owner_2 = msg.sender;
        _owner_3 = msg.sender;
    }

}