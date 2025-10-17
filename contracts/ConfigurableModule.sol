// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// type declarations (e.g. using Address for address)
// state vars

// events
// errors
// modifiers

// functions grouped by:
// - external
// - public
// - internal
// - private

/*
    🔒 Ownership Patterns

    1️⃣ Registry-owned:
    - Registry = owner.
    - Only registry can call privileged funcs (like updateMode).
    - Centralized, clean, secure.

    2️⃣ Creator-owned:
    - Module stores creator address.
    - Registry checks creator before updating.
    - More decentralized, but adds logic.

    💡 Tip: Keep modules dumb (just data + small setters),
    and let the registry handle all control logic. 💅

    This module is designed to be registry-owned. 
*/

// TODO: ❗ implement registry as owner
// TODO: ❗Switch to minimal proxy pattern (EIP-1167)
// Factory will deploy tiny proxies pointing to this logic contract.
// Registry will track owners + configs externally to keep clones dumb & cheap.
contract ConfigurableModule {
    address public controller;
    uint256 public index;

    uint256 public immutable creationConfig; // immutable config set at birth
    uint256 public mutableConfig; // mutable configs, slot 0 (immutable variable creationConfig does not affect storage layout)

    enum Mode {
        OFF, // 0
        LIVE, // 1
        PAUSED // 2

    }

    constructor(uint256 _creationConfig, uint256 _mutableConfig, uint256 _index, address _controller) {
        index = _index;
        controller = _controller;

        creationConfig = _creationConfig;
        mutableConfig = _mutableConfig;
    }

    // to keep bytecode small, explicit pause(), restart(), disable() are implemented in registry
    function updateMode(uint256 newMode) external {
        require(newMode <= 3, "Mode too big"); // max for 2 bits

        // Clear existing mode bits
        mutableConfig &= ~uint256(0x3); // clear bits 0 and 1

        // Set new mode bits
        mutableConfig |= newMode; // mode goes at offset 0
    }

    // NOTE: Only works for mutable configs
    function readStorageSlot(uint256 slot) external view returns (bytes32 value) {
        require(slot == 0, "Only config slot allowed");
        assembly {
            value := sload(slot)
        }
    }

    function getMode() public view returns (Mode) {
        return Mode(mutableConfig & 0x3);
    }
}
