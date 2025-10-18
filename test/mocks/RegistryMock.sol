import {IRegistry} from "../../contracts/interfaces/IRegistry.sol";

contract RegistryMock is IRegistry {
    address public lastModule;
    address public lastCaller;

    function registerModule(address module, address caller) external {
        lastModule = module;
        lastCaller = caller;
    }

    function moduleOwner(address module) external view returns (address) {
        if (module == lastModule) return lastCaller;
        return address(0);
    }
}
