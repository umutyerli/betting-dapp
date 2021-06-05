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

    function bet(uint _number) public payable {
        require(_number > 0 && _number <=10);
        require(msg.value >= minBet);

        uint winningNumber = block.number % 10 + 1;
        address payable winner = payable(msg.sender);

        if(_number == winningNumber) {
            uint amountWon = msg.value * (100 - houseEdge)/10;
            if(!winner.send(amountWon)) revert();
            emit Won(true, amountWon);
        } else {
            emit Won(false, 0);
        }
    }

    function checkContractBalance() public view Owned returns (uint256) {
        return address(this).balance;
    }

}