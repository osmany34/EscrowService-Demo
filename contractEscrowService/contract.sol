// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract EscrowService {
    address public payer;
    address public payee;
    address public arbiter;
    
    uint public amount;
    bool public isPaid = false;
    bool public isReleased = false;

    constructor(address _payee, address _arbiter) {
        payer = msg.sender;
        payee = _payee;
        arbiter = _arbiter;
    }

    function deposit() external payable {
        require(msg.sender == payer, "Only payer can deposit");
        require(!isPaid, "Funds already deposited");
        amount = msg.value;
        isPaid = true;
    }

    function releaseFunds() external {
        require(msg.sender == arbiter, "Only arbiter can release funds");
        require(isPaid, "Funds not deposited");
        require(!isReleased, "Funds already released");
        payable(payee).transfer(amount);
        isReleased = true;
    }

    function refund() external {
        require(msg.sender == arbiter, "Only arbiter can refund");
        require(isPaid, "Funds not deposited");
        require(!isReleased, "Funds already released");
        payable(payer).transfer(amount);
        isReleased = true;
    }
}
