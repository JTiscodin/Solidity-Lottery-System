pragma solidity ^0.8.0;

contract SimpleLottery {
    address public manager;   // The manager of the lottery
    address[] public players; // Array of players

    constructor() {
        manager = msg.sender; // The manager is the one who deploys the contract
    }

    // Function for a player to enter the lottery
    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum contribution is 0.01 ether");
        players.push(msg.sender);
    }

    // Function to pick a random winner
    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        address winner = players[index];
        payable(winner).transfer(address(this).balance); // Use payable() to enable the transfer function on the address
        players = new address[](0); // Reset the players array
    }

    // Modifier to restrict access to the manager
    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    // Generate a pseudo-random number based on the current block information
    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    // Function to get the list of players
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}