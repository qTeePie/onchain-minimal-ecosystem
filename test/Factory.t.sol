// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../contracts/factory/Factory.sol";

contract FactoryTest is Test {
    function testOwner() public {
        Factory factory = new Factory();
    }
}
