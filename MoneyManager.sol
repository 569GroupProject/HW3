// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract MoneyManager {
    uint public receivedAmount;
    uint public timeOut;

    event Withdrawal(address indexed recipient, uint amount);

    function receiveMoney() public payable {
        receivedAmount += msg.value;
        timeOut = block.timestamp + 1 minutes;
    }

    function currentBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        require(block.timestamp >= timeOut, "Withdrawal not allowed yet");
        address payable recipient = payable(msg.sender);
        uint balance = currentBalance();
        recipient.transfer(balance);
        emit Withdrawal(recipient, balance);
    }

    function withdrawToAddress(address payable _address) public {
        require(block.timestamp >= timeOut, "Cannot withdraw before timeout");
        require(address(this).balance > 0, "No balance to withdraw");
        uint balance = currentBalance();
        _address.transfer(balance);
        emit Withdrawal(_address, balance);
    }
}

