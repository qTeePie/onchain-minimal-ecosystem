✅ **Message 1 of 2 – Core MVP Spec**
(this is the part you’ll want inside `/docs/NOTES_MVP.md`)

---

```
# 🧠 Bridge Adapter MVP – Builder Notes (For Future Iz)

> This file is NOT a public README.
> It’s a "brain reboot" so Future Me remembers what the hell this project was about
> and doesn't get lost in the swamp of overthinking.
```

---

## 1. What this project _is_ (in 5 lines)

- A **modular, swappable cross-chain messaging layer** for EVM contracts.
- Apps call `sendMessage()` → registry decides which bridge adapter is active.
- The app contract stays **immutable**, but the bridge used underneath can change.
- Uses **Factory** to deploy adapters, not hard-coded addresses.
- MVP = **mock adapters + registry + factory + example app + tests.**
  _(No real bridging. Only events. That’s fine.)_

---

## 2. Real problem this solves

Many apps in crypto **died or froze** because they hard-coded a single bridge.

Examples:

- Multichain hack → 100s of dApps trapped forever
- Harmony bridge exploit → tokens stuck, no migration path
- Celer downtime → withdrawals frozen
- LayerZero outages → dependent dApps helpless
- Axelar pause → apps could not reroute messages

If your contract does:

```solidity
LayerZeroEndpoint.send(...);
```

→ you are **locked forever** to that bridge.
→ If it dies, you die.
→ Only way out = redeploy entire app, break state, force migration.

This repo = **solution to that trap**.

---

## 3. Why _registry + factory_ instead of "just upgradeable contracts"

| Pattern                               | Why Not                                                          |
| ------------------------------------- | ---------------------------------------------------------------- |
| Upgradable Proxy                      | Too much attack surface, not trust-minimized, full logic mutable |
| Hard-coded bridge                     | Permanent dependency → protocol death if bridge fails            |
| Router with static addresses          | Needs redeploy to change anything                                |
| “Just deploy a new version”           | Breaks state, breaks UI, breaks user balances                    |
| Per-bridge adapter _without_ registry | No coordination layer → app still chooses 1 forever              |

This pattern keeps app logic immutable, while still allowing bridge replacement **as infrastructure**, not via redeploy.

✅ No upgradable app logic
✅ Only external dependency is swappable
✅ Auditable surface area
✅ Deployment factory enforces uniform interface

---

## 4. MVP Scope (ONLY what is included)

✅ `BridgeRegistry.sol`

- maps `chainId → adapterAddress`
- onlyOwner can update for now (MVP)
- emits `AdapterUpdated(chainId, old, new)`

✅ `AdapterFactory.sol`

- deploys new adapters using EIP-1167 clones
- emits `AdapterDeployed(impl, cloneAddress)`

✅ `IBridgeAdapter.sol`

- unified interface all adapters must implement:

  ```
  function send(uint256 dstChainId, bytes calldata payload) external payable;
  ```

✅ Two mock adapters

- `LayerZeroAdapterMock.sol`
- `AxelarAdapterMock.sol`
  Both just emit events like:
  `MessageSent("LayerZero", dstChainId, payload)`

✅ `ExampleApp.sol`

- calls `registry.getAdapter(chainId).send(...)`
- no hard-coded bridge dependencies
- emits its own event for UI/test visibility

✅ Foundry tests

- adapter swap works
- wrong chainId reverts
- event logs correct
- factory deploys unique clones

✅ Minimal docs inside repo
_(not this doc – this is your private one)_

---

## 5. **NOT in MVP**

❌ DAO
❌ Timelock
❌ Whitelist / codehash validation
❌ User override parameter
❌ Emergency pause
❌ Real bridge relaying + cross-chain proof verification
❌ Slashing / staking / risk model
❌ Real multi-chain deploy scripts

These are **v2+ features**, not needed to prove the architecture.

---

## 6. Contract List (quick mental map)

```
/src
  BridgeRegistry.sol        // Stores active adapter per chain
  AdapterFactory.sol        // Deploys new adapters as clones
  IBridgeAdapter.sol        // Interface every adapter must implement
  adapters/
    LayerZeroAdapterMock.sol
    AxelarAdapterMock.sol
  ExampleApp.sol            // Example dApp that uses registry routing
```

---

## 7. Architecture

```
ExampleApp.sol
     │
     ▼
BridgeRegistry.sol ──> returns active adapter for chainId
     │
     ▼
Adapter (Mock)  <── deployed by AdapterFactory.sol
    │
    ▼
emit MessageSent(...)
```

✅ App never touches adapter addresses directly
✅ Adapter can be swapped without redeploying ExampleApp
✅ Future: DAO + timelock controls registry, not owner

---

## 8. Foundry Test Plan (must write)

```
testDefaultAdapter()
  - set adapter for chainId
  - call ExampleApp.sendMessage()
  - assert MessageSent() from correct adapter

testAdapterSwap()
  - set adapter A
  - send → event says “LayerZero”
  - set adapter B
  - send → event says “Axelar”
  - assert no redeploy of ExampleApp needed

testNoAdapterSet()
  - expect revert if chain has no registered adapter

testFactoryDeploysUnique()
  - deploy twice → assert different addresses
```

Optional but good:

```
testOnlyOwnerCanSetAdapter()
testEventEmissionOnSwap()
testZeroAddressRejected()
```

---

✅ **This is the core build spec.**
NOTES_MVP_SEC will contain:

- security notes
- links/EIPs to study later
- known bridge failures
- roadmap after MVP
- traps to avoid
- keywords for v2 research

**Reply "GO 2" and I’ll send Message 2.**
