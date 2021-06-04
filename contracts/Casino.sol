//SPDX-License-Identifier: MIT
pragma solidity >=0.4.10;

contract Ownable {
    address owner;

    constructor () {
        //Set owner to who creates the contract
        owner = msg.sender;
    }
    //Access modifier 
    modifier Owned {
        require(msg.sender == owner);
        _;
    }
}

contract Mortal is Ownable {
    //Our access modifier is present, only the contract creator can use this function
    function kill() public Owned { 
        selfdestruct(payable(owner));
    }
}

contract Casino is Mortal{
    uint minBet;
    uint houseEdge;

    event Won(bool _status, uint _amount);

    constructor(uint _minBet, uint _houseEdge) payable {
        require(_minBet > 0);
        require(_houseEdge <= 100);
        minBet = _minBet;
        houseEdge = _houseEdge;
    }

    fallback() external {
        revert();
    }

    // function bet(uint _number) payable public {
    //     require(_number > 0 && _number <=10);
    //     require(msg.value >= minBet);
    //     uint winningNumber = block.number
    // }

}