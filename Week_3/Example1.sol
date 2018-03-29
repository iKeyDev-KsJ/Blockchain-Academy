pragma solidity ^0.4.21;

contract BlockchainAcamedy {

    // 계좌의 토큰 잔고를 public 형태로 선언
    // public type => get method 자동 생성
    mapping (address=>uint256) public balanceOf;
}