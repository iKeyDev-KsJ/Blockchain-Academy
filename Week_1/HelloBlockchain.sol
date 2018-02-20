pragma solidity ^0.4.20;
contract HelloBlockchain {
    
    address owner;
    
    // Set Contract Caller in Owner
    function HelloBlockchain() public 
    {
        owner = msg.sender;
    }

    function hello() public constant returns(string)
    {
        return "hello";
    }
    
    function echoHello(string _hello) public returns(string) 
    {
        if (msg.sender != owner) revert();
        return _hello;   
    }

}