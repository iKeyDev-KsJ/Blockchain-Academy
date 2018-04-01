pragma solidity ^0.4.21;
import "../ERC-827/ERC827Interface.sol";

/*
    ERC-827 Interface를 확장하는 ERC-223 토큰 인터페이스
    https://github.com/ethereum/EIPs/issues/223
*/
contract ERC223Interface is ERC827Interface {
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
}