pragma solidity ^0.4.21;

/*

    Storage / Memory 소스 분석 결과

    Memory 타입은 기본 default이다.
    함수 내에 선언되는 모든 변수는 memory를 기본 인자값으로 한다.
    단, array / struct 타입의 경우는 memory or storage 중에서 1개를 택할 수 있다.



    만일 memory 타입이 되면
    push / pop을 사용할 수 없는 fixed array로 선언된다.
    또한 초기화 하는 방식은 동적 메모리 할당을 사용하느냐에 따라 달라진다.

    uint8[5] memory x = [1, 2, 3, 4, 5];
    방식을 통해서 초기화를 할 수 있고

    uint[] memory x = new uint8[](5);
    방식을 통해서만 초기화를 할 수 있다.

    new 연산자를 사용하는 경우에는 각 변수 값 지정 시
    반드시 x[0] = 1; 방식을 사용해야만 한다.

    for (uint i = 0; i < x.length; i++) {
        x[i] = i + 1;
    }

    방식을 통해서도 가능하다.



    만일 storage 타입이 되면
    초기화는 오로지 Smart Contract의 전역으로 선언되어 있는 array / struct 변수로 할 수 있다.
    즉 call by reference 타입이 되며,
    c언어식으로는

    uint8 *x = &data;
    방식이 된다는 것.

    push / pop을 사용할 수 있는 mutable array 타입의 변수가 되어
    사용시에 메모리를 매우 유동적으로 활용할 수 있게 된다.

    단, 비용이 매우 비싸진다는 단점이 있다.



    최종 결론ㄱ

    스마트 컨트랙의 내부 변수를 가져다 사용하는 경우와
    storage로 만든 공간에 할당받아 사용하는 것 모두 비용상 차이는 없으며
    바로 갖다 쓸 수 있다는 부분에 있어 어느 쪽을 택해도 무방할 듯 하다.

    하지만, storage를 사용하는 경우 아래와 같은 상황에서는 매우 유용할 수 있다.

    function a() {
        uint8[] storage x;

        ... 기타 작업

        b(x);
    }

    function b(uint8[] storage x) internal {
        x.push(8);
        ... 기타 작업
    }

    즉, 임의의 함수 a 내에서 선언된 초기화되지 않은 storage 변수를
    다른 함수 b에서 가져다 사용해야 하는데, 값의 변경이 그대로 적용되어야 하는 call by reference여야만 하는 경우
    해당 방식은 매우 유용할 수 있다.

    [다만 해당 경우가 반드시 필요한 케이스를 찾기 어려워 마땅한 예제를 들기는 어려울 듯 하다.]

    외의 경우 memory는 기본 타입이므로,
    그냥 사용해도 특별히 문제될 부분은 없을듯 하다.

    단, 초기화 방식이 앞서 언급했다시피 경우에 따라 다르므로
    선언시 유의해야할 필요가 있다. (물론 변수가 array 또는 struct인 경우에만 해당된다.)


*/
contract Example {

    uint8[] data;

    // memory 타입 변수 선언
    // uint8[index 개수] memory x = [~~~]; 로 초기화 가능
    // uint8[index 개수] x; 인 경우 storage or memory 타입인지 모호성이 발생
    // 이로 인해 [1, 2, 3, 4, 5]; 초기화 시도 시 오류 발생
    // push / pop 사용 불가능
    function a() public pure returns(uint8[5]){
        uint8[5] memory x = [1, 2, 3, 4, 5];
        // uint8[5] x = [1, 2, 3, 4, 5]; 오류 발생
        // uint8[5] storage x = [1, 2, 3, 4, 5]; 오류 발생, 좌측은 storage 우측은 memory 타입임
        return(x);
    }

    // uint8[] memory x = 동적으로 할당 가능
    // 단, 이렇게 할 경우 [1, 2, 3, 4, 5]; 방식으로 초기화 불가능
    // push / pop 사용 불가능
    function _a() public pure returns(uint8[]){
        uint8[] memory x = new uint8[](5); // 오로지 이 방식으로만 초기화 가능

        x[0] = 1;
        x[1] = 2;
        x[2] = 3;
        x[3] = 4;
        x[4] = 5;

        return(x);
    }

    // memory에 data를 담아 반환
    function b() public view returns(uint8[]){
        uint8[] memory x = data;
        return(x);
    }

    // storage에 data를 담아 반환
    function _b() public view returns(uint8[]){
        uint8[] storage x = data;
        return(x);
    }

    // 자체를 반환
    function __b() public view returns(uint8[]){
        return(data);
    }

    // 이하의 방법들은 모두 가스 소모량이 동일하다.
    function c() public {
        // uint8[] memory x = data;
        // 위 방법인 경우 x.push(1); 불가능
        uint8[] storage x = data;
        x.push(1);
    }

    function _c() public {
        data.push(2);
    }

    function __c() public {
        ___c(data);
    }

    // 인자값 자체를 storage로 받으려는 경우, internal type 함수에서만 가능하다
    // public은 오로지 memory 타입의 변수만을 인자값으로 받을 수 있다.
    function ___c(uint8[] storage x) internal {
        x.push(3);
    }

}