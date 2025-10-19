**Note: Constructor-bypass / extcodesize caveat**

- During a contract’s constructor, `EXTCODESIZE(address)` (and `.code.length`) returns `0` because the runtime bytecode hasn’t been written to the address yet.
- Attack vector: a malicious contract can call a target contract from _inside its constructor_ and bypass naive "no contracts" checks like `require(msg.sender.code.length == 0)`. That’s a one-shot bypass during deployment, but any state changes the target makes persist if the transaction succeeds.
- Demo pattern: attacker constructor calls `Vulnerable(target).enter()` while `extcodesize(this) == 0` → target treats caller as an EOA and grants privileges.
- Implication: **don’t rely on `extcodesize` as a security boundary**.
- Safer alternatives:

  1. **EIP-712 signatures** (recommended).
  2. Support **EIP-1271** for smart wallets.
  3. `tx.origin == msg.sender` blocks constructor-bypass but is dangerous (phishing/composability risks) — avoid unless you accept tradeoffs.
  4. Economic/time defenses (deposits, timelocks), or off-chain verification for human-only flows.

- Testing tip: Add a Foundry/Remix test that deploys an attacker contract whose constructor calls the vulnerable function to prove the bypass exists, then fix and re-test with signature gating.
- Quick mantra: `extcodesize` = heuristic, not a guarantee. Use crypto (signatures) for guarantees.

Target contract (vulnerable):

```solidity
pragma solidity ^0.8.17;

contract EoaOnly {
    mapping(address => bool) public granted;

    // naive EOA-only gate (vulnerable to constructor-bypass)
    function enter() external {
        require(msg.sender.code.length == 0, "no-contracts");
        granted[msg.sender] = true;
    }
}

```

Attacker contract (calls target from constructor):

```solidity
pragma solidity ^0.8.17;

interface IEoaOnly { function enter() external; }

contract CtorAttacker {
    constructor(address target) {
        IEoaOnly(target).enter(); // this call happens while this contract has code length == 0
    }
}

```
