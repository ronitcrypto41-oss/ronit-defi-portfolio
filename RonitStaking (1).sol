// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RonitStaking {
    mapping(address => uint256) public stakes;
    uint256 public totalStaked;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function stake() public payable {
        require(msg.value > 0, "Cannot stake 0 ETH");
        stakes[msg.sender] += msg.value;
        totalStaked += msg.value;
    }

    function unstake(uint256 amount) public {
        require(amount > 0, "Cannot unstake 0 ETH");
        require(stakes[msg.sender] >= amount, "Insufficient staked amount");
        stakes[msg.sender] -= amount;
        totalStaked -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Unstake failed");
    }

    function getStake(address user) public view returns (uint256) {
        return stakes[user];
    }

    function getTotalStaked() public view returns (uint256) {
        return totalStaked;
    }
}