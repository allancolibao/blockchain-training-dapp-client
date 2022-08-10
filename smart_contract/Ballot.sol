// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Ballot {
    
    address public chairperson;
    bool public votingEnabled;

    constructor(string[] memory _candidateNames){
        chairperson = msg.sender;
        for (uint i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate(
                _candidateNames[i],
                0
            ));
        }
    }

    modifier onlyChairperson {
        require(msg.sender == chairperson, 'access denied');
        _;
    }

    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint vote;
    }

    Candidate[] public candidates;

    function getCandidatesLength() public view returns(uint) {
        return candidates.length;
    }

    mapping (address => Voter) public voters;


    function setVotingState(bool _votingEnabled) public onlyChairperson {
        votingEnabled = _votingEnabled;
    }

    function vote(uint _candidate) external {
        require(votingEnabled == true, "voting must be enabled");
        require(voters[msg.sender].voted == false);

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = _candidate;
        candidates[_candidate].voteCount++;
    }

    function getWinningCandidate() public view returns(uint) {
        uint winningVoteCount;
        uint winningCandidate;

        for(uint index = 0; index < candidates.length; index++) {
            if(candidates[index].voteCount > winningVoteCount) {
                winningVoteCount = candidates[index]. voteCount;
                winningCandidate = winningCandidate;
            }
        }
        return winningCandidate;
    }

    function getWinner() public view returns(string memory) {
        uint winner = getWinningCandidate();
        if(candidates[winner].voteCount > 0) {
            return candidates[winner].name;
        }

        return '';
    }
}