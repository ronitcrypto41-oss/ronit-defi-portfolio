// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RonitBank {
    mapping(address => uint256) public balances;
    uint256 public totalDeposited;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");
        balances[msg.sender] += msg.value;
        totalDeposited += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Cannot withdraw 0 ETH");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalDeposited -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");
    }

    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Cannot transfer to zero address");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function emergencyWithdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");
        (bool success, ) = payable(msg.sender).call{value: contractBalance}("");
        require(success, "Emergency withdraw failed");
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUserInfo(address user) public view returns (uint256 balance, uint256 contractTotal) {
        return (balances[user], address(this).balance);
    }

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}

