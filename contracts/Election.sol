pragma solidity ^0.8.7;
contract Election{
    struct Voter{
        uint weight ;
        uint8 vote ;
        bool isVoted ;
    }

    address public organizerAdmin ;
    mapping(address => Voter) voters ;
    uint[4] proposals ;

    modifier onlySupperAdmin(){
       require(msg.sender == organizerAdmin);
       _;
    }

    constructor() public{
        organizerAdmin = msg.sender ;
        voters[organizerAdmin].weight = 1 ;
        voters[organizerAdmin].isVoted = false ;
    }

    function Register(address toVoter,address registerer) public {
        if(voters[toVoter].isVoted || registerer != organizerAdmin) revert() ;
        voters[toVoter].isVoted = false ;
        voters[toVoter].weight = 1 ;
    }

    function Vote(uint8 toProposal, address voterAddr) public{
        Voter memory sender = voters[voterAddr] ;
        if(sender.isVoted || toProposal>proposals.length || sender.weight == 0) revert() ;
        sender.isVoted = true ;
        sender.vote = toProposal ;
        proposals[toProposal] += sender.weight ;
    }

    function Winner() public view returns(uint _winningProposal){
        uint winningVoteCount = 0 ;
        for(uint prop=0;prop<4;prop++){
            if(proposals[prop] > winningVoteCount){
                winningVoteCount = proposals[prop] ;
                _winningProposal = prop ;
            }
        }
    }
}