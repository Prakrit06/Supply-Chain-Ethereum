pragma solidity ^0.8.4;

contract Ownable{
    address public _owner;
    
    constructor() public{
        _owner = msg.sender;
    }
    modifier OnlyOwner() {
        require(isOwner(), "You are not the owner"); 
        _;
    }
    function isOwner() public view returns(bool){
        return(msg.sender==_owner); 
    }
}
