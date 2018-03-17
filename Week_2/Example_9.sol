pragma solidity ^0.4.21;

contract Example {

    address _owner;

    function Example() payable public {
        _owner = msg.sender;
    }

    function () payable public {
        _owner.transfer(msg.value);
    }

    function multiWithdrawal(address[] receiver, uint256[] amount) payable public {
        uint256 sum;
        for (uint i = 0; i < amount.length; i++) {
            sum += amount[i];
        }

        assert(msg.value == sum);
        assert(receiver.length == amount.length);
        for (i = 0; i < receiver.length; i++) {
            receiver[i].transfer(amount[i]);
        }
    }
}