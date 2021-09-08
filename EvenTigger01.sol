pragma solidity ^0.8.4;

import "./Item01.sol";
import "./Ownable.sol";


contract ItemManager is Ownable{
    
    enum SupplyChainState{Created, Paid, Delivered} //unsigned integers starting from 0
    
    struct S_Item{
        Item _item; //obj of Item contract 
        string _identifier;
        
        uint _itemPrice;
        ItemManager.SupplyChainState _state; 
        
    }
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    event SupplyChainStep(uint _itemIndex, uint step, address _itemAddress);
    
    function createItem(string memory _identifier, uint _itemPrice) public OnlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex); 
        items[itemIndex]._item = item; 
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice; 
        items[itemIndex]._state = SupplyChainState.Created; //which is basically zero....
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }
    
    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payment is accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the Chain"); //if it doesnot need to be paid yet
        items[_itemIndex]._state == SupplyChainState.Paid;//sent full value but not paid yet
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
    
    function TriggerDelier(uint _itemIndex) public payable OnlyOwner{
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the Chain");
        items[_itemIndex]._state == SupplyChainState.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item)); 
    }
}
