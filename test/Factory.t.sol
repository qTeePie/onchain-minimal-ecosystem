// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// libraries
import "forge-std/Test.sol";
import "../contracts/factory/Factory.sol";
// locals
import {Factory} from "../contracts/factory/Factory.sol";

contract FactoryTest is Test {
    uint8 constant MODE_COUNT = 3; // OFF, LIVE, PAUSED
    uint256 constant MODE_COUNT_INVALIDS = 1; // OFF

    // registry will own the factory
    address immutable registry = makeAddr("registry");
    Factory factory;

    // Prevents VSCode false errors
    event ModuleCreated(address indexed module, uint256 indexed index, uint256 data);
    event ModuleDisabled(address indexed module, uint256 indexed index);

    enum Mode {
        OFF, // 0
        LIVE, // 1
        PAUSED // 2

    }

    /*//////////////////////////////////////////////////////////////
                           SETUP + DEPLOYMENT
    //////////////////////////////////////////////////////////////*/
    function setUp() public {
        factory = new Factory();
    }

    function testFactoryStartsEmpty() public view {
        assertTrue(factory.moduleCount() == 0);
    }

    /*//////////////////////////////////////////////////////////////
                              CREATEMODULE
    //////////////////////////////////////////////////////////////*/
    function testCreateModuleWorks() public {
        // start-count
        uint256 startCount = factory.moduleCount();

        // --- prepare configs ---
        address nftReceiver = makeAddr("nftReceiver");
        bool isPremium = true;
        Mode mode = Mode.LIVE;

        Factory.CreationConfig memory creationConfig =
            Factory.CreationConfig({NFTReceiver: nftReceiver, isPremium: isPremium});
        Factory.MutableConfig memory mutableConfig = Factory.MutableConfig({mode: uint8(mode)});

        // -- expect event fired, compute topic `data` (creationConfigs) ---
        uint256 expectedPackedCreation = (uint256(uint160(nftReceiver)) << 0) | (isPremium ? 1 << 160 : 0);

        vm.expectEmit(false, true, false, true, address(factory));
        emit ModuleCreated(address(0), factory.moduleCount() + 1, expectedPackedCreation);

        // --- create module / trigger events ---
        address moduleAddr = factory.createModule(creationConfig, mutableConfig);

        // --- post-conditions ---
        assertEq(factory.moduleCount(), startCount + 1, "Module count should increase");
        assertEq(factory.modules(startCount), moduleAddr, "Stored module mismatch");
    }

    function testModuleAddressStoredCorrectly() public {
        // compare module = modules[0]
        // assertEqual(module, emittedAddress)
    }

    function testCreateModuleRevertsOnInvalidMode() public {
        // call createModule with mode > 1
        // expect revert "Invalid mode"
    }

    /*//////////////////////////////////////////////////////////////
                             PACKING LOGIC
    //////////////////////////////////////////////////////////////*/
    function testPackedCreationContainsReceiver() public {
        // decode the packed creation value from emitted event
        // confirm lower 160 bits == NFTReceiver address
    }

    function testPackedCreationPremiumFlag() public {
        // check if the isGold bit is set correctly at bit 160
    }

    /*//////////////////////////////////////////////////////////////
                            MULTIPLE MODULES
    //////////////////////////////////////////////////////////////*/
    function testMultipleModulesStoredSequentially() public {
        // create a few modules
        // assert: modules array stores each one in order
        // assert: event index matches array index
    }

    /*//////////////////////////////////////////////////////////////
                          EDGE-CASES / EVENTS
    //////////////////////////////////////////////////////////////*/
    function testModuleCreatedEventEmitted() public {
        // use vm.expectEmit / ethers event matcher
        // check for correct params
    }

    /*//////////////////////////////////////////////////////////////
                                REGISTRY
    //////////////////////////////////////////////////////////////*/
    function testModuleDisabledEvent() public {
        // placeholder — once you implement disable()
    }

    // -----------------------
    // 🔧 PRIVATE HELPERS
    // -----------------------
    function mockCreationConfig() internal pure returns (Factory.CreationConfig memory config) {
        // generate a pseudo address from a fixed seed
        address receiver = address(uint160(uint256(keccak256("mock_receiver_seed"))));

        // alternate true/false in a deterministic way (or just fix one)
        bool isPremium = (uint256(keccak256("mock_premium_seed")) & 1 == 0);

        config = Factory.CreationConfig({NFTReceiver: receiver, isPremium: isPremium});
    }

    function mockMutableConfig() internal pure returns (Factory.MutableConfig memory config) {
        uint8 mode = uint8(1 + (uint256(keccak256("mock_mode_seed")) % (MODE_COUNT - MODE_COUNT_INVALIDS)));

        config = Factory.MutableConfig({mode: mode});
    }

    // generates module with params
    function spawnModule(address nftReceiver, bool isPremium, uint8 mode) internal returns (address) {
        return factory.createModule(
            Factory.CreationConfig({NFTReceiver: nftReceiver, isPremium: isPremium}),
            Factory.MutableConfig({mode: mode})
        );
    }

    //  generates some configurable module
    function spawnModule() internal returns (address moduleAddr) {
        Factory.CreationConfig memory creationConfig = mockCreationConfig();
        Factory.MutableConfig memory mutableConfig = mockMutableConfig();

        moduleAddr = factory.createModule(creationConfig, mutableConfig);
    }
}
