// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract MoneyManager {
    uint public receivedAmount;
    uint public timeOut;

    event Withdrawal(address indexed recipient, uint amount);

    mapping(address => uint) public deposits;
    mapping(address => uint) public depositTimeouts;

    function receiveMoney() public payable {
        receivedAmount += msg.value;
        deposits[msg.sender] += msg.value;
        depositTimeouts[msg.sender] = block.timestamp + 1 minutes;
    }

    function currentBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        require(block.timestamp >= depositTimeouts[msg.sender], "Withdrawal not allowed yet");
        address payable recipient = payable(msg.sender);
        uint withdrawalAmount = deposits[msg.sender];
        require(withdrawalAmount > 0, "No balance to withdraw");
        deposits[msg.sender] = 0;
        recipient.transfer(withdrawalAmount);
        emit Withdrawal(recipient, withdrawalAmount);
    }

    function withdrawToAddress(address payable _address) public {
        require(block.timestamp >= depositTimeouts[msg.sender], "Cannot withdraw before timeout");
        uint withdrawalAmount = deposits[msg.sender];
        require(withdrawalAmount > 0, "No balance to withdraw");
        deposits[msg.sender] = 0;
        _address.transfer(withdrawalAmount);
        emit Withdrawal(_address, withdrawalAmount);
    }
}


