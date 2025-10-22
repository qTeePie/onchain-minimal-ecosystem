// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// type declarations
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

// ❗ TODO: Implement registry as owner
// ❗ TODO: Switch to minimal proxy pattern (EIP-1167)
contract ConfigurableModule {
    enum Mode {
        OFF, // 0
        LIVE, // 1
        PAUSED // 2

    }

    uint256 public creationConfig; // config set at birth
    uint256 public mutableConfig; // mutable configs

    address public controller;
    uint256 public index;
    bool private initialized; // later for eip-1167 compliance

    modifier onlyController() {
        require(msg.sender == controller, "not controller");
        _;
    }

    constructor() {
        controller = msg.sender; // temporary ownership to factory
    }

    // -----------------------
    // EXTERNAL
    // -----------------------
    function initialize(uint256 _creationConfig, uint256 _mutableConfig, uint256 _index, address _controller)
        external
    {
        require(!initialized, "already init");
        require(msg.sender == controller, "not controller");

        index = _index;
        controller = _controller;

        creationConfig = _creationConfig;
        mutableConfig = _mutableConfig;

        initialized = true;
    }

    // explicit pause(), restart(), disable() are implemented in registry
    function updateMode(uint256 newMode) external onlyController {
        require(newMode <= 3, "Mode too big"); // max for 2 bits

        // Clear existing mode bits
        mutableConfig &= ~uint256(0x3); // clear bits 0 and 1

        // Set new mode bits
        mutableConfig |= newMode; // mode goes at offset 0
    }

    // -----------------------
    // VIEW
    // -----------------------
    function readStorageSlot(uint256 slot) external view returns (bytes32 value) {
        require(slot == 0, "Only config slot allowed");
        assembly {
            value := sload(slot)
        }
    }

    function getMode() public view returns (Mode) {
        return Mode(mutableConfig & 0x3);
    }

    /* ❗ TODO: implement RBAC so only owner (not controller) can call destroy() 
    function destroy() external onlyOwner {
    // emit event BEFORE selfdestruct
    emit AboutToDie(address(this), msg.sender);

    // notify registry BEFORE selfdestruct
    IRegistry(controller).onModuleDestroyed(address(this));

    // then selfdestruct
    selfdestruct(payable(msg.sender));
    }
    */
}
