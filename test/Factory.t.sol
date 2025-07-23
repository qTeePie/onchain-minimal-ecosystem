// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patterns/factory/Factory.sol";

contract FactoryTest is Test {
    function testOwner() public {
        Factory factory = new Factory();
        assertEq(factory.owner(), address(this));
    }
}
