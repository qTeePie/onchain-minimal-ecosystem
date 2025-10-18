// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// libraries
import "forge-std/Test.sol";
// locals
import {Factory} from "../../contracts/Factory.sol";
import {RegistryMock} from "../mocks/RegistryMock.sol";
// for create2 bytecode
import {ConfigurableModule} from "../../contracts/ConfigurableModule.sol";

contract FactoryTest is Test {
    uint8 constant MODE_COUNT = 3; // OFF, LIVE, PAUSED
    uint8 constant MODE_COUNT_INVALIDS = 1; // OFF

    // registry will own the factory
    RegistryMock registryMock; // temporary placeholder for mock
    Factory factory;

    // Prevents VSCode false errors
    event ModuleCreated(address indexed module, uint256 indexed index, uint256 data);
    event ModuleDisabled(address indexed module, uint256 indexed index);

    /*//////////////////////////////////////////////////////////////
                           SETUP + DEPLOYMENT
    //////////////////////////////////////////////////////////////*/
    function setUp() external {
        registryMock = new RegistryMock();
        factory = new Factory(registryMock);
    }

    function testFactoryStartsEmpty() external view {
        assertEq(factory.moduleCount(), 0);
    }

    /*//////////////////////////////////////////////////////////////
                              CREATEMODULE
    //////////////////////////////////////////////////////////////*/
    function testCreateModuleWorks() external {
        // start-count
        uint256 startCount = factory.moduleCount();

        // --- prepare configs ---
        address creator = makeAddr("creator");
        uint256 timestamp = uint256(keccak256("mock_timestamp"));
        bool premium = true;
        uint8 mode = 1;

        Factory.CreationConfig memory creationConfig = makeCreationConfig(creator, timestamp, premium);
        Factory.MutableConfig memory mutableConfig = Factory.MutableConfig({mode: mode});

        // -- expect event fired, compute topic `data` (creationConfigs) ---
        uint256 expectedPackedCreation = (uint256(uint160(creationConfig.creator)) << 0)
            | (creationConfig.premium ? (1 << 160) : 0) | (uint256(uint40(creationConfig.timestamp)) << 161);

        // TODO: implement checks topic 1 (create2)
        vm.expectEmit(false, true, false, true, address(factory));
        emit ModuleCreated(address(0), factory.moduleCount(), expectedPackedCreation);

        // --- create module / trigger events ---
        address moduleAddr = factory.createModule(creationConfig, mutableConfig);

        // --- post-conditions ---
        assertEq(factory.moduleCount(), startCount + 1, "Module count should increase");
        assertEq(factory.modules(startCount), moduleAddr, "Stored module mismatch");
    }

    function testModuleAddressStoredCorrectlyInFactory() external {
        // --- expect and create module ---
        uint256 expectedIndex = factory.moduleCount();
        address moduleAddr = spawnModule();

        assertEq(moduleAddr, factory.modules(expectedIndex));
    }

    function testCreate2AddressComputationWorks() external {
        // --- mock salt params ---
        Factory.CreationConfig memory creationConfig = mockCreationConfig();
        uint256 index = factory.moduleCount();

        // --- compute predicted salt + module creationCode ---
        bytes32 predictedSalt = keccak256(abi.encodePacked(creationConfig.creator, index));
        bytes memory bytecode = type(ConfigurableModule).creationCode;

        // compute predicted access
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(factory), predictedSalt, keccak256(bytecode)));
        address predictedAddr = address(uint160(uint256(hash)));

        // -- spawn module
        Factory.MutableConfig memory mutableConfig = mockMutableConfig();
        address deployed = spawnModule(creationConfig, mutableConfig);

        assertEq(predictedAddr, deployed);
    }

    function testCreateModuleCreationRevertsOnInvalidMode() external {
        // --- Init invalid  ---
        uint8 invalidMode = invalidModuleCreationMode();
        uint256 startCount = factory.moduleCount();

        // --- expect and trigger revert ---
        vm.expectRevert(bytes("Invalid mode"));
        spawnModule(invalidMode);

        // --- test modulecount is unchanged ---
        uint256 endCount = factory.moduleCount();
        assertEq(endCount, startCount, "Module count should not change on revert");
    }

    /*//////////////////////////////////////////////////////////////
                             PACKING LOGIC
    //////////////////////////////////////////////////////////////*/
    function testPackedCreationContainsReceiver() external {
        // decode the packed creation value from emitted event
        // confirm lower 160 bits == creator address
    }

    function testPackedCreationPremiumFlag() external {
        // check if the isGold bit is set correctly at bit 160
    }

    /*//////////////////////////////////////////////////////////////
                            MULTIPLE MODULES
    //////////////////////////////////////////////////////////////*/
    function testMultipleModulesStoredSequentially() external {
        // create a few modules
        // assert: modules array stores each one in order
        // assert: event index matches array index
    }

    // -----------------------
    // 🔧 PRIVATE HELPERS
    // -----------------------
    function validModuleCreationMode() private pure returns (uint8 mode) {
        uint8 validRange = MODE_COUNT - MODE_COUNT_INVALIDS;
        uint256 hash = uint256(keccak256("mock_mode_seed"));
        mode = uint8(MODE_COUNT_INVALIDS + (hash % validRange));
    }

    function invalidModuleCreationMode() private pure returns (uint8 mode) {
        uint256 hash = uint256(keccak256("mock_mode_seed"));
        mode = uint8((hash % MODE_COUNT_INVALIDS));
    }

    function mockMutableConfig() private pure returns (Factory.MutableConfig memory config) {
        config = Factory.MutableConfig({mode: validModuleCreationMode()});
    }

    function makeCreationConfig(address creator, uint256 timestamp, bool premium)
        private
        pure
        returns (Factory.CreationConfig memory config)
    {
        config = Factory.CreationConfig({creator: creator, timestamp: timestamp, premium: premium});
    }

    function mockCreationConfig() private pure returns (Factory.CreationConfig memory config) {
        // generate a pseudo address & timestamp from seed
        address creator = address(uint160(uint256(keccak256("mock_owner_seed"))));
        uint256 timestamp = uint256(keccak256("mock_timestamp"));
        bool premium = (uint256(keccak256("mock_premium_seed")) & 1 == 0);

        config = makeCreationConfig(creator, timestamp, premium);
    }

    function spawnModule(Factory.CreationConfig memory creationConfig, Factory.MutableConfig memory mutableConfig)
        internal
        returns (address)
    {
        return factory.createModule(creationConfig, mutableConfig);
    }

    // spawns module, mocks all params except mode
    function spawnModule(uint8 mode) internal returns (address) {
        return factory.createModule(mockCreationConfig(), Factory.MutableConfig({mode: mode}));
    }

    // spawns module, mocks all params
    function spawnModule() internal returns (address moduleAddr) {
        Factory.CreationConfig memory creationConfig = mockCreationConfig();
        Factory.MutableConfig memory mutableConfig = mockMutableConfig();

        moduleAddr = factory.createModule(creationConfig, mutableConfig);
    }
}
