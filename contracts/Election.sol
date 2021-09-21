<<<<<<< HEAD
pragma solidity ^0.8.7;
contract Election{
    struct Voter{
        uint weight ;
        uint8 vote ;
        bool isVoted ;
        bool isRegister;
    }

    address public organizerAdmin ;
    mapping(address => Voter) voters ;
    uint[3] proposals ;
    uint8 public totalVoters ;
    uint8 public totalVotes;

    event LogVote (address indexed userAddress, uint8 index);
    event LogRegister(address toVoter,address registerer);
    event LogGetTotalVotes(string  msg, uint8 totalVotes);
    event LogGetTotalVoters(string  msg, uint8 totalVoters);

    modifier onlySupperAdmin(){
       require(msg.sender == organizerAdmin);
       totalVoters =0;
       totalVotes =0;
       _;
    }

    constructor() public{
        organizerAdmin = msg.sender ;
        voters[organizerAdmin].weight = 1 ;
        voters[organizerAdmin].isVoted = false ;
    }

    function Register(address toVoter,address registerer) public {
        if(voters[toVoter].isVoted || voters[toVoter].isRegister  || registerer != organizerAdmin) {
            revert() ;
        } else {
            voters[toVoter].isVoted = false ;
            voters[toVoter].isRegister = true;
            totalVoters++;
            voters[toVoter].weight = 1 ;
            emit LogRegister(toVoter,registerer);
        }

    }
    function getTotalVoters() public  returns(uint8 _total){
         _total = totalVoters;
         emit LogGetTotalVoters( "Total Votes event",  totalVoters);
    }

    function getTotalVotes() public  returns(uint8 _total){
         _total =  totalVotes;
         emit LogGetTotalVotes( "Total Votes event",  totalVotes);
    }
    function getCandidateVote(uint candidateId) public view returns( uint _vote) {
        assert(msg.sender != organizerAdmin);
        return proposals[candidateId];
    }
    function Vote(uint8 toProposal, address voterAddr) public{
        Voter memory sender = voters[voterAddr] ;
        if( sender.isVoted || !sender.isRegister || toProposal>proposals.length || sender.weight == 0)  {
            revert() ;
        }else {
            sender.isVoted = true ;
            sender.vote = toProposal ;
            proposals[toProposal] += sender.weight ;
            voters[voterAddr]  = sender;
            totalVotes++;
            emit LogVote(voterAddr,toProposal);
        }

    }

    function Winner() public view returns(uint _winningProposal){
        uint winningVoteCount = 0 ;
        for(uint prop=0;prop<3;prop++){
            if(proposals[prop] > winningVoteCount){
                winningVoteCount = proposals[prop] ;
                _winningProposal = prop ;
            }
        }
    }
=======
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
>>>>>>> 853b590b398fe1978e138235133df6b7e387c06a
}