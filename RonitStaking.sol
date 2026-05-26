
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RonitBank {
    mapping(address => uint256) public balances;
    uint256 public totalDeposited;

    // Deposit ETH
    function deposit() public payable {
        require(msg.value > 0, "Cannot deposit 0 ETH");
        balances[msg.sender] += msg.value;
        totalDeposited += msg.value;
    }

    // Withdraw ETH
    function withdraw(uint256 amount) public {
        require(amount > 0, "Cannot withdraw 0 ETH");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        totalDeposited -= amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");
    }

    // View functions
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getTotalDeposited() public view returns (uint256) {
        return totalDeposited;
    }
}

