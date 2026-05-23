// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleVoting {
    mapping(address => bool) public hasVoted;
    mapping(string => uint256) public votes;
    string[] public candidates;

    function addCandidate(string memory name) public {
        candidates.push(name);
    }

    function vote(string memory candidate) public {
        require(!hasVoted[msg.sender], "You have already voted");
        bool exists = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(bytes(candidates[i])) == keccak256(bytes(candidate))) {
                exists = true;
                break;
            }
        }
        require(exists, "Candidate does not exist");
        
        votes[candidate] += 1;
        hasVoted[msg.sender] = true;
    }

    function getVotes(string memory candidate) public view returns (uint256) {
        return votes[candidate];
    }
}
