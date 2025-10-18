// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IRegistry} from "./interfaces/IRegistry.sol";
import {Factory} from "./Factory.sol";

contract Registry {
    mapping(address => address) public moduleToOwner;
    Factory public factory;

    event ModuleRegistered(address indexed module, address indexed creator);

    // -----------------------
    // EXTERNAL
    // -----------------------
    function registerModule(address module, address creator) external {
        require(msg.sender == address(factory), "not factory");
        moduleToOwner[module] = creator;
        emit ModuleRegistered(module, creator);
    }

    // -----------------------
    // VIEW
    // -----------------------
    function moduleOwner(address module) external view returns (address) {
        return moduleToOwner[module];
    }
}
