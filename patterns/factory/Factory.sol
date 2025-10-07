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
    uint256 public disabledCount; // tracks disabled children

    /**
     * Logs who deployed it, where it lives, and what data it holds.
     *
     *  Basics of events:
     * - Indexed params become topics in the event log entry
     * - Indexers such as *The Graph* etc. can filter by these fields.
     * - Non-indexed fields (here data and timestamp) are stored in a blob structure and are not searchable.
     */
    event ChildCreated(address indexed child, uint256 indexed index, uint256 data);
    event ChildDisabled(address indexed child, uint256 indexed index);

    error AlreadyDisabled();

    function createChild(uint256 data) external {
        Child child = new Child(data, children.length);
        children.push(child);
        emit ChildCreated(address(child), children.length - 1, data);
    }

    function getChildren() external view returns (Child[] memory enabledChildren) {
        uint256 total = children.length;
        uint256 active = total - disabledCount;
        enabledChildren = new Child[](active); // init array with capacity = active

        uint256 count;
        for (uint256 i = 0; i < total; i++) {
            // auto generated getter for child.isEnabled field
            if (children[i].isEnabled()) {
                enabledChildren[count] = children[i];
                count++;
            }
        }
    }

    function disable(Child child) external {
        uint256 idx = child.index();
        if (!children[idx].isEnabled()) revert AlreadyDisabled();

        children[idx].disable();
        disabledCount++;
        emit ChildDisabled(address(child), idx);
    }
}

contract Child {
    uint256 public immutable data;
    uint256 public immutable index;
    bool public isEnabled;

    constructor(uint256 _data, uint256 _index) {
        data = _data;
        index = _index;
        isEnabled = true;
    }

    function disable() external {
        require(isEnabled, "Already disabled");
        isEnabled = false;
    }
}
