pragma solidity ^0.8.4;

import "./EventTrigger01.sol";

contract Item{
    //responsible for taking payments and handing back the paymnet to ItemManager(contract)
    //contract item gets it own address to take payments
    
    uint public priceInWei;
    uint public PricePaid;
    uint public index;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public{
        priceInWei= _priceInWei;
        index=_index;
        parentContract=_parentContract; 
    }
    
    receive() external payable {
        // sending only money without any data populated
        require(PricePaid ==0, "Item is paid already");
        require(priceInWei==msg.value, "Only full payments allowed");
        PricePaid+= msg.value;
       (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));// index for TriggerPayment _itemIndex
       //will return bool as no return type specified for the function TriggerFunction
       require(success, "The transaction was not successful, cancelling"); 
}

        fallback() external{
    }
}
