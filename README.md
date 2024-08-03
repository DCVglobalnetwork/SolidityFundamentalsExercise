# Solidity Fundamentals Exercise: Timelock and SimpleStorage Contracts

## Introduction

> This project demonstrates the basics of Solidity through two smart contracts: Timelock and SimpleStorage. The Timelock contract restricts certain actions until a specified time has passed, while the > >SimpleStorage contract allows for storing and retrieving a number, with a dependency on the Timelock contract for access control.

## Contracts
`Timelock.sol`

The Timelock contract is designed to lock certain actions until a specific period has elapsed. It includes the following functionalities:

+ State Variables:

+ unlockTime: The timestamp after which the lock is released.

+ owner: The address that deployed the contract and has the permissions to extend the lock and withdraw funds.

+ Modifiers:
+ onlyOwner: Ensures that only the owner can call certain functions.

+ Constructor:
Accepts _lockDuration (in seconds) and sets the unlockTime based on the current block timestamp.

+ Functions:
extendLock(uint256 _additionalTime): Allows the owner to extend the lock duration.
withdraw(): Allows the owner to withdraw funds after the unlockTime.
isLocked(): Returns true if the current time is before unlockTime, false otherwise.

```shell
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Timelock {
    uint256 public unlockTime;
    address private immutable owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor(uint256 _lockDuration) {
        owner = msg.sender;
        unlockTime = block.timestamp + _lockDuration;
    }

    function extendLock(uint256 _additionalTime) public onlyOwner {
        unlockTime += _additionalTime;
    }

    function withdraw() public onlyOwner {
        require(block.timestamp >= unlockTime, "Funds are still locked");
        // Logic to withdraw funds goes here
    }

    function isLocked() public view returns (bool) {
        return block.timestamp < unlockTime;
    }
}
```

`SimpleStorage.sol`

The SimpleStorage contract allows storing and retrieving a number, with a dependency on the Timelock contract to control when the number can be updated.

+ State Variables:
  
+ storedNumber: The number stored in the contract.
  
+ timelock: An instance of the Timelock contract.
  
+ _owner: The address that deployed the contract and has the permissions to update the number.
+ Modifiers:
+ onlyOwner: Ensures that only the owner can call certain functions.
+ Constructor:
Accepts the address of a deployed Timelock contract and sets the owner of the SimpleStorage contract.
+ Functions:
setNumber(uint256 _number): Allows the owner to set a new number if the timelock is not active.
getNumber(): Returns the stored number.

```shell
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Timelock.sol";

contract SimpleStorage {
    uint256 private storedNumber;
    Timelock private timelock;

    event NumberUpdated(uint256 oldNumber, uint256 newNumber);

    address private _owner;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    constructor(address _timelockAddress) {
        _owner = msg.sender;
        timelock = Timelock(_timelockAddress);
    }

    function setNumber(uint256 _number) public onlyOwner {
        require(!timelock.isLocked(), "Timelock is still active");
        uint256 oldNumber = storedNumber;
        storedNumber = _number;
        emit NumberUpdated(oldNumber, _number);
    }

    function getNumber() public view returns (uint256) {
        return storedNumber;
    }
}
```
# Prerequisites
Ensure you have the following installed:

Node.js
Hardhat

Steps
1. Clone the repository:
```shell
git clone https://github.com/DCVglobalnetwork/SolidityFundamentalsExercise.git
```
2. Install dependencies:

```shell
npm install

```
3. Compile the contracts:
   
```shell
npx hardhat compile

```

| Command | Description |
| --- | --- |
| npm install | Node.js to install the dependencies listed in a project's |
| npx hardhat | Create a Hardhat project|
| npx hardhat compile | Compile all the Solidity contracts in project |

## Conclusion
This project provides an introduction to Solidity fundamentals, focusing on contract state management, and access control using time-based conditions.
The Timelock and SimpleStorage contracts showcase how to implement basic Solidity concepts and integrate them within a larger application.


