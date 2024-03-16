// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0;

contract Lottery{
    //entities - manager, players and winner
    address public manager;
    address payable[] public players;
    address payable  public  winner;

    //Constructor functions get called on deployment, thus giving manager address to whosoever calling the function
    constructor(){
        manager = msg.sender;
    }

    function participate() public payable{
        require(msg.value == 1 ether, "Please Pay 1 ether only"); //every participant needs to spend 1 ether to participate in the lottery
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(manager == msg.sender,"You are not the manager");
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    }

    function pickWinner() public {
        require(manager==msg.sender,"You are not the manager");
        require(players.length>=3,"Players are less than 3");

        uint r = random();
        uint index = r%players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0); //This will initialize the array back to 0
    }

}