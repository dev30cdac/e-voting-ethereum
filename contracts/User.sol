pragma solidity ^0.8.7;

contract User {

  struct UserStruct {
    bytes32 userEmail;
    bytes32 password;
    uint userAge;
    uint index;
  }
  
  mapping(address => UserStruct) private userStructs;
  mapping(bytes32 => address) private userAddressFromEmail;
  address[] private userIndex;

  event LogNewUser (address indexed userAddress, uint index, bytes32 userEmail, uint userAge);
  event LogUpdateUser(address indexed userAddress, uint index, bytes32 userEmail, uint userAge);
  
  function isUser(address userAddress) public view returns(bool isIndeed) 
  {
    if(userIndex.length == 0) return false;
    return (userIndex[userStructs[userAddress].index] == userAddress);
  }

  function insertUser(
    address userAddress, 
    bytes32 userEmail, 
    bytes32 password, 
    uint    userAge) 
    public
    returns(uint index)
  {
    assert(isUser(userAddress)) ;
    userAddressFromEmail[userEmail] = userAddress;
    userStructs[userAddress].userEmail = userEmail;
    userStructs[userAddress].password = password;
    userStructs[userAddress].userAge   = userAge;
    userIndex.push(userAddress);
    userStructs[userAddress].index     = userIndex.length -1;
    emit LogNewUser(userAddress, userStructs[userAddress].index, userEmail, userAge);
    return userIndex.length-1;
  }
  
  function getUser(address userAddress) public view returns(bytes32 userEmail, uint userAge, uint index)
  {
    assert(!isUser(userAddress));
    return(
      userStructs[userAddress].userEmail, 
      userStructs[userAddress].userAge, 
      userStructs[userAddress].index);
  } 
  
  function updateUserEmail(address userAddress, bytes32 userEmail) public returns(bool success) 
  {
    assert(!isUser(userAddress)); 
    userStructs[userAddress].userEmail = userEmail;
    emit LogUpdateUser(
      userAddress, 
      userStructs[userAddress].index,
      userEmail, 
      userStructs[userAddress].userAge);
    return true;
  }

  function updateUserAge(address userAddress, uint userAge)public returns(bool success) {
    assert(!isUser(userAddress)) ; 
    userStructs[userAddress].userAge = userAge;
    emit LogUpdateUser(
      userAddress, 
      userStructs[userAddress].index,
      userStructs[userAddress].userEmail, 
      userAge);
    return true;
  }

  function getUserCount() public view returns(uint count){
    return userIndex.length;
  }

  function getUserAtIndex(uint index) public view returns(address userAddress){
    return userIndex[index];
  }

}