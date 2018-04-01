pragma solidity ^0.4.21;
import "./ERC827Interface.sol";
import "../ERC-20/ERC20.sol";

/*
    ERC-827 토큰 발행
    ERC827Interface 및 ERC20을 상속한다.
    https://github.com/ethereum/EIPs/issues/827
*/

contract ERC827 is ERC827Interface, ERC20 {

    function ERC827(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) 
             ERC20(_initialAmount, _tokenName, _decimalUnits, _tokenSymbol) public {
    }

    // transfer 오버로딩
    function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
        require(_to != address(this));                                  // 컨트랙 주소로 토큰 송금 방지
        require(super.transfer(_to, _value));                           // EIP20 transfer 호출
        require(_to.call(_data));                                       // 컨트랙 _data 호출
        return true;
    }

    // transferFrom 오버로딩
    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool success) {
        require(_to != address(this));                                  // 컨트랙 주소로 토큰 송금 방지
        require(super.transferFrom(_from, _to, _value));                // EIP20 transferFrom 호출
        require(_to.call(_data));                                       // 컨트랙 _data 호출
        return true;
    }

    // approve 오버로딩
    function approve(address _spender, uint256 _value, bytes _data) public returns (bool success) {
        require(_spender != address(this));                             // 컨트랙 주소로 토큰 출금 대리자 설정 방지
        require(super.approve(_spender, _value));                       // EIP20 approve 호출
        require(_spender.call(_data));                                  // 컨트랙 _data 호출
        return true;
    }
}
