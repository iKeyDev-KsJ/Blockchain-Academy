pragma solidity ^0.4.21;
import "./ERC20Interface.sol";

/*
    ERC-20 토큰 발행
    ERC20Interface를 상속한다.
*/
contract ERC20 is ERC20Interface {

    /*
        계좌 잔고 확인 가능한 balances 변수 생성 (getter 생략)
        인출 가능 수량 확인 가능한 allowed 변수 생성 (getter 생략)
    */
    mapping(address=>uint256) internal balances;
    mapping(address=>mapping(address=>uint256)) internal allowed;
    
    /*
        이하 3 변수는 옵션이다 (강제 아님)
        name: 토큰 이름
        decimals: 보여질 소수 자릿수 설정
        symbol: 토큰 심볼
    */
    string public name;
    uint8 public decimals;
    string public symbol;

    function ERC20(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
        balances[msg.sender] = _initialAmount;               // 토큰 발행자에게 초기 토큰 발행 수량 전체 지급
        totalSupply = _initialAmount;                        // 총 발행량 설정
        name = _tokenName;                                   // 표시될 토큰 이름 설정
        decimals = _decimalUnits;                            // 표시될 소수 자릿수 설정
        symbol = _tokenSymbol;                               // 표시될 토큰 심볼 설정
    }

    // 토큰 소유자 잔고 확인
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // 토큰 송금 msg.sender -> _to (_value)
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));                             // 잘못된 address 검사
        require(balances[msg.sender] >= _value);                // 잔고 확인
        require(balances[_to] + _value >= balances[_to]);       // 오버플로우 확인

        balances[msg.sender] -= _value;                         // 출금자 잔고 차감
        balances[_to] += _value;                                // 수령자 잔고 증액

        emit Transfer(msg.sender, _to, _value);                 // 이벤트 로그 발행
        return true;
    }

    // 토큰 송금 _from -> _to (_value)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];                 // 대리 출금 허용 잔금 변수 설정

        require(_from != address(0) && _to != address(0));              // 잘못된 address 검사
        require(balances[_from] >= _value && allowance >= _value);      // _from 잔고 확인 및 출금 가능 허용 잔고 확인
        require(balances[_to] + _value >= balances[_to]);               // 오버플로우 확인

        balances[_to] += _value;                                        // 수령자 잔고 증액
        balances[_from] -= _value;                                      // 출금자 잔고 차감

        allowed[_from][msg.sender] -= _value;                           // 대리 출금자 허용 잔고 차감

        emit Transfer(_from, _to, _value);                              // 이벤트 로그 발행
        return true;
    }

    // 대리 출금 허용 잔금 확인
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];   // 허용액 반환
    }

    // 대리 출금 잔고 허용 _spender (_value)
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_value < 2**256 - 1);                   // 최대 허용액 설정

        allowed[msg.sender][_spender] = _value;         // 대리 출금 허용 잔금 설정

        emit Approval(msg.sender, _spender, _value);    // 이벤트 로그 발행
        return true;
    }
}