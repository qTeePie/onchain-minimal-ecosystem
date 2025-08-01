// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Factory {
    // Dummy content for now
    address public owner;

    constructor() {
        owner = msg.sender;
    }
}
