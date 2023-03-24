// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract MoneyManager {
    uint public receivedAmount;
    uint public timeOut;

    function receiveMoney() public payable {
        receivedAmount += msg.value;
    }

    function currentBalance() public view returns (uint) {
        return address(this).balance;
    }
}
