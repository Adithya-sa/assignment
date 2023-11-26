// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    mapping(string => uint256) private votesReceived;
    address public chairperson;
    mapping(address => bool) private voters;
    bool public votingStopped;

    string[] private candidateList;

    constructor(string[] memory candidateNames) {
        chairperson = msg.sender;
        candidateList = candidateNames;
    }

    modifier onlyChair() {
        require(msg.sender == chairperson, 'Only chairperson');
        _;
    }

    modifier isVotingStopped() {
        require(votingStopped == true, 'Voting is not stopped');
        _;
    }

    modifier isVotingNotStopped() {
        require(votingStopped == false, 'Voting is stopped');
        _;
    }

    modifier isValidVoter() {
        require(voters[msg.sender] == true, 'Voter is not valid');
        _;
    }

    function totalVotesFor(string memory candidate) public view onlyChair isVotingStopped returns (uint256) {
        require(validCandidate(candidate));
        return votesReceived[candidate];
    }

    function castVote(string memory candidate) public isVotingNotStopped isValidVoter {
        require(validCandidate(candidate));
        votesReceived[candidate] += 1;
    }

    function validCandidate(string memory candidate) public view returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
            if (keccak256(bytes(candidateList[i])) == keccak256(bytes(candidate))) {
                return true;
            }
        }
        return false;
    }

    function validVoter(address voter) public view returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
            if (voters[voter] == true) {
                return true;
            }
        }
        return false;
    }

    function addVoter(address voter) public onlyChair {
        voters[voter] = true;
    }

    function stopVoting() public onlyChair {
        votingStopped = true;
    }
}