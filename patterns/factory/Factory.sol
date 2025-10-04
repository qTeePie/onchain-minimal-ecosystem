// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// type declarations, e.g. using Address for address
// state vars

// events

// errors

// modifiers

// functions grouped by
// - external
// - public
// - internal
// - private

contract Factory {
    Child[] public children;
    uint256 public totalChildren;

    /**
     * Logs who deployed it, where it lives, and what data it holds.
     *
     *  Basics of events:
     * - Indexed params become topics in the event log entry
     * - Indexers such as *The Graph* etc. can filter by these fields.
     * - Non-indexed fields (here data and timestamp) are stored in a blob structure and are not searchable.
     */
    event ChildCreated(
        address indexed child, address indexed creator, uint256 indexed childId, uint256 data, uint256 timestamp
    );

    function createChild(uint256 data) public {
        totalChildren++;
        Child child = new Child(data);
        children.push(child);

        emit ChildCreated(address(child), msg.sender, totalChildren, data, block.timestamp);
    }
}

contract Child {
    uint256 public data;

    constructor(uint256 _data) {
        data = _data;
    }
}
