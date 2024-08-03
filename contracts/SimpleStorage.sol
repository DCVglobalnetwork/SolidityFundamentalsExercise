// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the Timelock contract to use its functionality
import "./Timelock.sol";

// A contract to store and update a number with access controlled by Timelock
contract SimpleStorage {
    // State variable to store a number
    uint256 private storedNumber;

    // Instance of the Timelock contract
    Timelock private timelock;

    // Event emitted when the number is updated
    event NumberUpdated(uint256 oldNumber, uint256 newNumber);

    // Address of the owner who has control over the contract
    address private _owner;

    // Modifier to restrict function access to the owner only
    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    // Constructor to initialize the contract
    // Sets the owner and assigns the Timelock contract address
    constructor(address _timelockAddress) {
        _owner = msg.sender; // Set the owner to the address deploying the contract
        timelock = Timelock(_timelockAddress); // Initialize the Timelock contract instance
    }

    // Function to update the stored number
    // Only callable by the owner and if Timelock is not active
    function setNumber(uint256 _number) public onlyOwner {
        require(!timelock.isLocked(), "Timelock is still active"); // Check if Timelock is not active
        uint256 oldNumber = storedNumber; // Store the old number before updating
        storedNumber = _number; // Update the stored number
        emit NumberUpdated(oldNumber, _number); // Emit an event with old and new numbers
    }

    // Function to retrieve the stored number
    // Publicly accessible
    function getNumber() public view returns (uint256) {
        return storedNumber; // Return the current stored number
    }
}
