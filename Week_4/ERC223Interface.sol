pragma solidity ^0.4.21;

/*
**  ERC-223 Token 표준안을 충족하는 ERC 223 Interface
**  https://github.com/ethereum/EIPs/issues/223
*/
contract ERC223Interface {

    // 토큰 송금
    // _to : 받는이 주소
    // _value : 수량
    function transfer(address _to, uint256 _value) public returns (bool success);

    // _from에 의해 승인된 조건 하, 토큰 송금
    // _from: 보내는이 주소
    // _to: 받는 이 주소
    // _value: 수량
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    // _owner: 토큰 실 소유 주소
    // _spender: 전송 가능한 토큰 계정 주소
    // (remaining): 지불 가능한 토큰 잔고 수량
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // msg.sender로부터 _spender 승인
    // _spender: spedner 주소
    // _value: 허용 수량
    function approve(address _spender, uint256 _value) public returns (bool success);

    // 이벤트
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event FundTransfer(address backer, uint amount, bool isContribution);
}
