// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/utils/ReentrancyGuard.sol";

/// @title RonitBank - A decentralized banking protocol
/// @author Ronit
/// @notice Allows users to deposit, withdraw and transfer ETH securely
contract RonitBank is Ownable, ReentrancyGuard {

    mapping(address => uint256) public balances;
    uint256 public totalDeposited;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor() Ownable(msg.sender) {}

    /// @notice Deposit ETH into your bank account
    /// @dev Requires msg.value greater than 0
    function deposit() public payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");
        balances[msg.sender] += msg.value;
        totalDeposited += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice Withdraw ETH from your bank account
    /// @dev Protected against reentrancy attacks
    /// @param amount The amount of ETH to withdraw in wei
    function withdraw(uint256 amount) public nonReentrant {
        require(amount > 0, "Cannot withdraw 0 ETH");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalDeposited -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");
        emit Withdraw(msg.sender, amount);
    }

    /// @notice Transfer ETH to another user inside the bank
    /// @param to The address to transfer to
    /// @param amount The amount to transfer in wei
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Cannot transfer to zero address");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    /// @notice Emergency withdraw — only callable by owner
    /// @dev Withdraws entire contract balance to owner
    function emergencyWithdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "Nothing to withdraw");
        (bool success, ) = payable(owner()).call{value: contractBalance}("");
        require(success, "Emergency withdraw failed");
    }

    /// @notice Check your own balance
    /// @return Your current ETH balance in the bank
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    /// @notice Check total ETH held by the contract
    /// @return Total ETH balance of the contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
