// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IRegistry} from "./interfaces/IRegistry.sol";
import {ConfigurableModule} from "./ConfigurableModule.sol";

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
🏗️ Factory + Registry Patterns

1️⃣ Coupled:
- Factory calls Registry directly after each deployment.
- Always in sync (auto-registers new modules).
- Simpler, but tighter link between contracts.

2️⃣ Decoupled:
- Factory only emits events; Registry (or off-chain indexer)
  listens and updates separately.
- Looser coupling, easier upgrades, but needs manual sync.

💡 Use coupled for on-chain coordinatii just on, decoupled for flexibility.

This factory uses a decoupled design — registry syncs via events instead of direct calls.

*/

contract Factory {
    IRegistry public registry;
    address[] public modules; // tracks addresses

    // -----------------------
    // CONFIG
    // -----------------------

    /// `creationConfig` = locked in at birth
    struct CreationConfig {
        address creator;
        bool isPremium;
        uint256 timestamp;
    }

    /// `mutableConfig` = tweakable stuff later
    struct MutableConfig {
        uint8 mode;
    }

    // -----------------------
    // EVENTS
    // -----------------------
    event ModuleCreated(address indexed module, uint256 indexed index, uint256 data);
    event ModuleDisabled(address indexed module, uint256 indexed index);

    constructor(IRegistry _registry) {
        registry = _registry; // 💅 plug in the registry at deploy time
    }

    function createModule(CreationConfig calldata creationConfig, MutableConfig calldata mutableConfig)
        external
        returns (address module)
    {
        // module cannot be spawned in an OFF state
        require(mutableConfig.mode != 0, "Invalid mode");

        uint256 packedCreation = (uint256(uint160(creationConfig.creator)) << 0)
            | (creationConfig.isPremium ? (1 << 160) : 0) | (uint256(uint40(creationConfig.timestamp)) << 161);

        uint256 packedMutable = (uint256(mutableConfig.mode) << 0);

        ConfigurableModule deployed =
            new ConfigurableModule(packedCreation, packedMutable, modules.length, address(registry));
        modules.push(address(deployed));

        // TODO: 💌 tell the registry (insert IRegistry in constructor later)
        //registry.registerModule(address(newModule), msg.sender);

        emit ModuleCreated(address(deployed), moduleCount() - 1, packedCreation);

        module = address(deployed);
    }

    function moduleCount() public view returns (uint256) {
        return modules.length;
    }

    //function getByteCode(address registry) {}
}
