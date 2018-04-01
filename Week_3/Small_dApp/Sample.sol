pragma solidity ^0.4.21;

/*
    Blockchain Academy 토큰 발행
    최소한의 기능만을 사용한 토큰 컨트랙트
*/
contract BCA {

    // 계좌의 토큰 잔고를 public 형태로 선언
    // public type => get method 자동 생성
    mapping (address=>uint256) public balanceOf;

    // BCA(초기 발행량) 생성자
    // 컨트랙 발행자의 계좌에 초기 발행량 제공
    function BCA(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }

    // 토큰 송금(받는이, 수량)
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);           // 보내는 계정 잔고 확인
        require(balanceOf[_to] + _value >= balanceOf[_to]); // 오버플로우 확인
        balanceOf[msg.sender] -= _value;                    // 보내는 계정 잔고 제거
        balanceOf[_to] += _value;                           // 받는 계정 잔고 추가
    }

}
