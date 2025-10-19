# Ownable: What, Why and How?

https://docs.openzeppelin.com/contracts/5.x/access-control

Open Zeppelin has minimal implementation of both

1. Ownable.sol
   For simpler contracts that has only one role, the _owner_.
2. AccessControl.sol
   For RBAC (role based access control).

---

## Ownable

`Ownable` is a pattern used for contracts with a single administrative user. The `owner` is set to the provided `initialOwner` parameter.

https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

The "hack" behind `Ownable` is the modifier `onlyOwner`.
When attached to a function, it runs `_checkOwner` before the function body and reverts if the caller isn’t the owner.

```solidity
/**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }
```

---

## AccessControl

> OpenZeppelin Contracts provides AccessControl for implementing role-based access control. Its usage is straightforward: for each role that you want to define, you will create a new role identifier that is used to grant, revoke, and check if an account has that role.

**example implementation (from OZ docs)**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AccessControlERC20MintBase is ERC20, AccessControl {
    // Create a new role identifier for the minter role
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    error CallerNotMinter(address caller);

    constructor(address minter) ERC20("MyToken", "TKN") {
        // Grant the minter role to a specified account
        _grantRole(MINTER_ROLE, minter);
    }

    function mint(address to, uint256 amount) public {
        // Check that the calling account has the minter role
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            revert CallerNotMinter(msg.sender);
        }
        _mint(to, amount);
    }
}
```
