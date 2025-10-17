// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

interface IRegistry {
    // -----------------------
    // EVENTS
    // -----------------------

    event ModuleRegistered(address indexed module, address indexed creator, uint256 index);
    // event ModuleOwnershipTransferred(address indexed module, address indexed oldOwner, address indexed newOwner);
    // event ModuleDisabled(address indexed module);
    // event RegistryPaused(bool status);

    // -----------------------
    // CORE REGISTRY FUNCTIONS
    // -----------------------

    /// @notice Called by Factory after deployment (or manually by creator in decoupled mode)
    function registerModule(address module, address creator) external;

    /*
    /// @notice Returns the creator/owner of a given module
    function moduleOwner(address module) external view returns (address);

    /// @notice Allows transferring ownership of a specific module
    function transferModuleOwnership(address module, address newOwner) external;

    /// @notice Marks a module as disabled / archived
    function disableModule(address module) external;

    /// @notice Returns if a module is currently registered
    function isRegistered(address module) external view returns (bool);

    /// @notice Returns if a module is currently disabled
    function isDisabled(address module) external view returns (bool);

    /// @notice Returns total module count
    function totalModules() external view returns (uint256);

    // -----------------------
    // ACCESS CONTROL / SAFETY
    // -----------------------

    /// @notice Check if caller has registry-level admin privileges
    function isAdmin(address account) external view returns (bool);

    /// @notice Pauses all registry activity (emergency switch)
    function setPaused(bool status) external;
    */
}
