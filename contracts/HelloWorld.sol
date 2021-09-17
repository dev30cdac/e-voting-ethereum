pragma solidity ^0.8.7;
contract HelloWorld {
    string public yourName ;
    constructor () public {
        yourName = "Group-4" ;
    }
    function setName(string memory nm) public{
        yourName = nm ;
    }
}