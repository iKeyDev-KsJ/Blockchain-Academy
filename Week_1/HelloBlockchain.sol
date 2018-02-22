pragma solidity ^0.4.20;
contract HelloBlockchain {
    
    address _owner;
    
    //
    function HelloBlockchain() public {
        _owner = msg.sender;
    }

    //
    function hello() public constant returns(string) {
        return "hello";
    }
    
    //
    function echoHello(string message) public returns(string) {
        if (msg.sender != _owner) revert();
        return message;   
    }

}