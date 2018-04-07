pragma solidity ^0.4.21;

import "./ERC223ReceivingInterface.sol";
import "./ERC223Interface.sol";
import "../ERC-827/ERC827.sol";

/*
    ERC-223 토큰 발행
    ERC-827 토큰을 상속한다.
    https://github.com/ethereum/EIPs/issues/223
*/
contract ERC223 is ERC223Interface, ERC827 {

    // ERC223 생성자
    function ERC223(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) 
             ERC827(_initialAmount, _tokenName, _decimalUnits, _tokenSymbol) public {
    }
    
    // transfer 오버로딩
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));                             // 잘못된 address 검사
        require(balances[msg.sender] >= _value);                // 잔고 확인
        require(balances[_to] + _value >= balances[_to]);       // 오버플로우 확인

        uint codeLength;                                        // 컨트랙 판별을 위한 변수
        bytes memory empty;                                     // 공백 바이트 생성

        /*
            인라인 어셈블리
        */
        assembly {
            codeLength := extcodesize(_to)                      // _to 주소 타입 확인
        }

        balances[msg.sender] -= _value;                         // 잔고 차감
        balances[_to] += _value;                                // 잔고 증액

        /*
            컨트랙 주소인 경우에 대한 처리
        */
        if(codeLength > 0) {
            ERC223ReceivingInterface receiver = ERC223ReceivingInterface(_to);
            receiver.tokenFallback(msg.sender, _value, empty);
        }

        emit Transfer(msg.sender, _to, _value, empty);          // 이벤트 발생
        return true;
    }

    // transfer 오버로딩
    function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
        require(_to != address(0));                             // 잘못된 address 검사
        require(balances[msg.sender] >= _value);                // 잔고 확인
        require(balances[_to] + _value >= balances[_to]);       // 오버플로우 확인

        uint codeLength;                                        // 컨트랙 판별을 위한 변수

        /*
            인라인 어셈블리
        */
        assembly {
            codeLength := extcodesize(_to)                      // _to 주소 타입 확인
        }

        balances[msg.sender] -= _value;                         // 잔고 차감
        balances[_to] += _value;                                // 잔고 증액

        /*
            컨트랙 주소인 경우에 대한 처리
        */
        if(codeLength > 0) {
            ERC223ReceivingInterface receiver = ERC223ReceivingInterface(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }

        emit Transfer(msg.sender, _to, _value, _data);          // 이벤트 발생
        return true;
    }
}