// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// type declarations, e.g. using Address for address
// state vars

// events

// errors

// modifiers

// functions are first grouped by
// - external
// - public
// - internal
// - private
// note how the external functions "descend" in order of how much they can modify or interact with the state

contract Factory {
    // Dummy content for now
    address public owner;

    // indexed = args stored as log topics, off-chain indexers use these for filtering.
    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);

    // Call this function to deploy a new pair of tokens.
    function createPair(address tokenA, address tokenB) external returns (address pair) {}

    constructor() {
        owner = msg.sender;
    }
}
