pragma solidity ^0.4.21;
import "./ERC223Interface.sol";
import "./ERC223ReceivingInterface.sol";

/*
**  ERC-223 토큰 발행
**  ERC223Interface를 상속한다.
**  https://github.com/ethereum/EIPs/issues/223
*/
contract ERC223 is ERC223Interface {
    
    // 컨트랙 발행자
    address private owner;
    
    /*
    ** totalSupply: 토큰 총 발행량
    ** corwdsaleAmount: 크라우드 세일 총 발행량
    ** amountRaised: 크라우드 세일 잔여 수량
    ** tokenPerOneEther: 토큰 수량 / 1 ether
    */
    uint256 public totalSupply;
    
    uint256 public crowdsaleAmount;
    uint256 public amountRaised;
    
    uint256 public tokenPerOneEther;

    /*
    **  계좌 잔고 확인 가능한 balances 변수 생성 (getter 생략)
    **  인출 가능 수량 확인 가능한 allowed 변수 생성 (getter 생략)
    */
    mapping(address=>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) internal allowed;
    
    /*
    **  이하 3 변수는 옵션이다 (강제 아님)
    **  name: 토큰 이름
    **  decimals: 보여질 소수 자릿수 설정
    **  symbol: 토큰 심볼
    */
    string public name;
    uint256 public decimals;
    string public symbol;

    // ERC223 크라우드 세일 토큰 발행
    function ERC223(uint256 _initialAmount, uint256 _crowdsaleAmount, uint256 _tokenPerOneEther, string _tokenName, uint256 _decimalUnits, string _tokenSymbol) public {
        owner = msg.sender;                                                                                // 발행자 주소 설정
        balanceOf[msg.sender] = (_initialAmount - _crowdsaleAmount) * (10 ** _decimalUnits);               // 토큰 발행자에게 초기 토큰 발행 수량 전체 지급
        
        totalSupply = _initialAmount * (10 ** _decimalUnits);               // 총 발행량 설정
        crowdsaleAmount = _crowdsaleAmount * (10 ** _decimalUnits);         // 크라우드 세일 발행량           
        amountRaised = _crowdsaleAmount * (10 ** _decimalUnits);            // 크라우드 세일 참여 가능 수량
        tokenPerOneEther = _tokenPerOneEther * (10 ** _decimalUnits);       // 1 이더당 토큰 수량
        
        name = _tokenName;                                    // 표시될 토큰 이름 설정
        decimals = _decimalUnits;                             // 표시될 소수 자릿수 설정
        symbol = _tokenSymbol;                                // 표시될 토큰 심볼 설정
    }
    
    // 이더 송금을 통한 크라우드 세일 참여
    function () public payable {
        uint256 amount = tokenPerOneEther * msg.value / 1 ether;            // 발급받을 토큰 수량 계산

        require(amountRaised - amount >= 0);                                // 참여 가능한 잔여 수량 확인
        require(msg.sender != address(0));                                  // 주소 점검
        require(msg.sender != owner);                                       // 발행자 점검
        require(msg.value >= 10 ** decimals);                               // 최소 참여 수량 점검
        require(balanceOf[msg.sender] + amount >= balanceOf[msg.sender]);   // 오버 플로우 확인
        
        balanceOf[msg.sender] += amount;                    // 토큰 발급
        amountRaised -= amount;                             // 참여 가능한 잔여 수량 차감
        
        owner.transfer(msg.value);                          // 발행자에게 ether 전송
        
        emit FundTransfer(msg.sender, amount, true);        // 이벤트 로그 발행
    }

    // 토큰 송금 msg.sender -> _to (_value)
    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 value = _value * (10 ** decimals);                          // decimals를 고려한 수량 계산
        
        require(_to != address(0));                                         // 잘못된 address 검사
        require(balanceOf[msg.sender] >= _value * (10 ** decimals));        // 잔고 확인
        require(balanceOf[_to] + value >= balanceOf[_to]);                  // 오버플로우 확인

        uint codeLength;                                       // 컨트랙 판별을 위한 변수

        /*
        **  인라인 어셈블리
        */
        assembly {
            codeLength := extcodesize(_to)                     // _to 주소 타입 확인
        }

        balanceOf[msg.sender] -= value;                        // 출금자 잔고 차감
        balanceOf[_to] += value;                               // 수령자 잔고 증액

        /*
        **  컨트랙 주소인 경우에 대한 처리
        */
        if(codeLength > 0) {
            ERC223ReceivingInterface receiver = ERC223ReceivingInterface(_to);
            receiver.tokenFallback(msg.sender, value);
        }

        emit Transfer(msg.sender, _to, value);          // 이벤트 로그 발행
        return true;
    }

    // 토큰 송금 _from -> _to (_value)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];                 // 대리 출금 허용 잔금 변수 설정
        uint256 value = _value * (10 ** decimals);                      // decimals를 고려한 수량 계산

        require(_from != address(0) && _to != address(0));              // 잘못된 address 검사
        require(balanceOf[_from] >= value && allowance >= value);       // _from 잔고 확인 및 출금 가능 허용 잔고 확인
        require(balanceOf[_to] + value >= balanceOf[_to]);              // 오버플로우 확인

        uint codeLength;                                                // 컨트랙 판별을 위한 변수

        /*
        **  인라인 어셈블리
        */
        assembly {
            codeLength := extcodesize(_to)                              // _to 주소 타입 확인
        }

        balanceOf[_to] += value;                                        // 수령자 잔고 증액
        balanceOf[_from] -= value;                                      // 출금자 잔고 차감

        allowed[_from][msg.sender] -= value;                            // 대리 출금자 허용 잔고 차감

        /*
        **  컨트랙 주소인 경우에 대한 처리
        */
        if(codeLength > 0) {
            ERC223ReceivingInterface receiver = ERC223ReceivingInterface(_to);
            receiver.tokenFallback(msg.sender, value);
        }

        emit Transfer(_from, _to, value);                               // 이벤트 로그 발행
        return true;
    }

    // 대리 출금 허용 잔금 확인
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];                               // 허용액 반환
    }

    // 대리 출금 잔고 허용 _spender (_value)
    function approve(address _spender, uint256 _value) public returns (bool success) {
        uint256 value = _value * (10 ** decimals);                      // decimals를 고려한 수량 계산
        require(value < 2**256 - 1);                                    // 최대 허용액 설정

        allowed[msg.sender][_spender] = value;                          // 대리 출금 허용 잔금 설정

        emit Approval(msg.sender, _spender, value);                     // 이벤트 로그 발행
        return true;
    }
    
}