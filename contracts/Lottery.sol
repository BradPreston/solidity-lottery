pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    
    function Lottery() public { // constructor function
        manager = msg.sender; // msg is a -global- variable. This sets the manager to the person who created the contract
    }
    
    function enter() public payable { // payable allows ether to be sent
        require(msg.value > .01 ether); // requires you to send at least .01 ether
        players.push(msg.sender); // adds the address of the player to the array of players
    }
    
    function random() private view returns(uint) { // helper function to generate a random number
        return uint(sha3(block.difficulty, now, players)); // returns a uint of a sha3 hash
    }
    
    function pickWinner() public restricted { // notice the "restricted" modifier
        uint index = random() % players.length; // generates a random number between 0 and the amount of players entered
        address winner = players[index]; // selects the winner's address at the position at the random number
        winner.transfer(this.balance); // gives the winner all the money in the lottery
        
        players = new address[](0); // creates a new empty dynamic array of player addresses with a size of 0
    }
    
    function getPlayers() public view returns (address[]) {
        return players;
    }
    
    modifier restricted() { // use modifiers to keep code d.r.y.
        require(msg.sender == manager); // make sure that ONLY the manager can pick a winner
        _; // anywhere that this modifier is called, the code inside that function will replace the underscore (think copy/paste)
    }
}