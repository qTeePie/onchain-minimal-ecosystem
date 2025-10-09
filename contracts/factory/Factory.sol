// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./ConfigurableModule.sol";

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
    // IRegistry public registry;
    address[] public modules; // tracks addresses

    /// fields gotta be <= 256bits
    struct CreationConfig {
        address NFTReceiver; // creator can set an address to get a cute NFT as reward (maybe grandma? 👵💜)
        bool isGold; // activates any premium features
    }

    /// fields gotta be <= 256bits
    struct MutableConfig {
        uint8 mode;
    }

    event ModuleCreated(address indexed module, uint256 indexed index, uint256 data);
    event ModuleDisabled(address indexed module, uint256 indexed index);

    // TODO: add IRegistry param in constructor once registry contract is ready
    /*constructor(IRegistry _registry) {
        registry = _registry; // 💅 plug in the registry at deploy time
    }*/

    /// `creationConfig` = locked in at birth
    /// `mutableConfig` = tweakable stuff later
    function createModule(CreationConfig calldata creationConfig, MutableConfig calldata mutableConfig)
        external
        returns (address module)
    {
        // creating a module can only be LIVE or OFF (pause cannot be a starting value)
        require(mutableConfig.mode <= 1, "Invalid mode");

        uint256 packedCreation =
            (uint256(uint160(creationConfig.NFTReceiver)) << 0) | (creationConfig.isGold ? 1 << 160 : 0);
        uint256 packedMutable = (uint256(mutableConfig.mode) << 0);

        ConfigurableModule deployed = new ConfigurableModule(packedCreation, packedMutable, modules.length);
        modules.push(address(deployed));

        // TODO: 💌 tell the registry (insert IRegistry in constructor later)
        //registry.registerModule(address(newModule), msg.sender);

        emit ModuleCreated(address(deployed), modules.length - 1, packedCreation);

        module = address(deployed);
    }
}
