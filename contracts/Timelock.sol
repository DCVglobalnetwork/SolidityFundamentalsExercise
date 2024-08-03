// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// A contract to manage a time-based lock on certain functions
contract Timelock {
    // Time when the lock will be lifted
    uint256 public unlockTime;

    // Address of the owner who has control over the contract
    address private immutable owner;

    // Modifier to restrict function access to the owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Constructor to initialize the lock duration and set the owner
    constructor(uint256 _lockDuration) {
        owner = msg.sender; // Set the owner to the address deploying the contract
        unlockTime = block.timestamp + _lockDuration; // Calculate the unlock time
    }

    // Function to extend the lock duration
    // Only callable by the owner
    function extendLock(uint256 _additionalTime) public onlyOwner {
        unlockTime += _additionalTime; // Add additional time to the unlock time
    }

    // Function to withdraw funds
    // Only callable by the owner, and only if the lock time has passed
    function withdraw() public view onlyOwner {
        require(block.timestamp >= unlockTime, "Funds are still locked"); // Check if the current time is past the unlock time
        // Logic to withdraw funds goes here (e.g., transfer funds to the owner)
    }

    // Function to check if the lock is still active
    function isLocked() public view returns (bool) {
        return block.timestamp < unlockTime; // Return true if current time is before unlock time
    }
}
