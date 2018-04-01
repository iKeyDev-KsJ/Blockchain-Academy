pragma solidity ^0.4.21;

/*
    ERC-223 토큰을 위한 더미 인터페이스
*/
contract ERC223ReceivingInterface { 
    function tokenFallback(address _from, uint _value, bytes _data) public;
}