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
    uint256 public disabledCount;

    event ChildCreated(address indexed child, uint256 indexed index, uint256 data);
    event ChildDisabled(address indexed child, uint256 indexed index);

    function createChild(uint256 data) external {
        Child child = new Child(data, children.length);
        children.push(child);
        emit ChildCreated(address(child), children.length - 1, data);
    }

    function getChildren() external view returns (Child[] memory enabledChildren) {
        uint256 total = children.length;
        uint256 active = total - disabledCount;
        enabledChildren = new Child[](active);

        uint256 count;
        for (uint256 i = 0; i < total; i++) {
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

    error AlreadyDisabled();
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
