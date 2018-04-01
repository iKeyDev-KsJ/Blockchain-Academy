pragma solidity ^0.4.21;
import "../ERC-20/ERC20Interface.sol";

/*
    ERC-20 Token 을 확장하는 ERC-827 토큰 인터페이스
    https://github.com/ethereum/EIPs/issues/827
*/
contract ERC827Interface is ERC20Interface {
    function transfer(address _to, uint256 _value, bytes _data) public returns (bool);
    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns(bool);
    function approve(address _spender, uint256 _value, bytes _data) public returns (bool);
}