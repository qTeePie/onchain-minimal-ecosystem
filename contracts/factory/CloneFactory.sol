// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 *  OpCode CREATE (*new* keyword) has a very high gas cost.
 *  Each time Factory.sol creates an instance of the Child contract, these gas costs compound quick.
 *  Since these contracts have identical bytecodes, we can use a pattern named *cloned factory pattern*
 *
 *  This contract is based on OpenZeppelin's Clones.sol: openzeppelin-contracts/tree/master/contracts
 *  For the sake of learning, the dev (me) have dissected OZ code, deciding on what to include in my minimal implementation.
 *
 *   Unlike OZ Clones.sol, this is a contract (not library) for convenience sake.
 *
 *  🧩 what really happens when you use a library with internal functions:
 *
 * When a contract calls an internal library function, the compiler inlines that code inside the calling function’s bytecode.
 * That means the library’s function no longer “exists” as a separate callable thing — it’s now literally part of the parent contract’s function body.
 *
 * So there’s no “inherited” accessibility; instead, the library’s code executes at the exact visibility level of wherever you called it.
 */
contract CloneFactory {
    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
        if (result == address(0)) revert CloneCreationFailed();
    }

    function isClone(address target, address query) internal view returns (bool result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
            mstore(add(clone, 0xa), targetBytes)
            mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            let other := add(clone, 0x40)
            extcodecopy(query, other, 0, 0x2d)
            result := and(eq(mload(clone), mload(other)), eq(mload(add(clone, 0xd)), mload(add(other, 0xd))))
        }
    }

    error CloneCreationFailed();
}
