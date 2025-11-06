# Oracle-Based Adapter Routing (Future Extension)

> This is NOT part of the MVP.  
> This is a **future upgrade path** for when I want to learn the oracle pattern
> without building an entire oracle network from scratch.

## 1. Why Oracle Pattern

Right now the system works like this:

    App → Registry → Adapter → Bridge

The **registry owner** decides which adapter is active.

That works for MVP, but it still has one weakness:

> It depends on a human (or multisig) to notice a bridge is down and switch adapters manually.

An oracle extension would change that into:

    App → Registry → Oracle → Best Adapter → Bridge

Meaning:

- The **app is still immutable**
- The **bridge is still swappable**
- But the **decision of which bridge to use is automated based on real-time status data**

So the oracle pattern turns the system from:

❒ “manually switch bridges when something breaks”  
into  
✅ **“self-healing cross-chain router”**

This solves the exact problem that killed hundreds of dApps during:

- Multichain shutdown
- Harmony Horizon bridge hack
- Axelar temporary halt
- LayerZero endpoint pauses
- Celer downtime

Those apps died because they **hard-coded a single bridge**.  
My architecture already fixes that _manually_.  
The oracle pattern fixes it _autonomously_.

So this is **a natural v3 upgrade**, not a random feature.

---

## 2. What the oracle actually does

It does NOT send messages cross-chain.

It does NOT replace adapters.

It does NOT touch app logic.

The oracle **only reports the health/state/score of each bridge**, something like:

```

LayerZero: healthy ✅
Axelar: degraded ⚠️
Hyperlane: halted ❌

```

The registry then routes based on that health data.

---

## 3. How to prototype this w/o a real oracle network

✅ Step 1 — Add a simple “BridgeStatusOracle.sol” contract  
✅ Step 2 — For now, make it `onlyOwner` or `onlyBot()`  
✅ Step 3 — Simulate status updates in tests:

```solidity
oracle.setStatus("LayerZero", HEALTHY);
oracle.setStatus("Axelar", HALTED);
```

✅ Step 4 — Extend registry to either:

- block sending through unhealthy bridges, or
- auto-select “highest score” adapter

✅ Step 5 — Write Foundry tests that simulate downtime

That’s enough to **learn the pattern** without touching Chainlink OCR.

---

## 4. What to postpone for later

These are things that belong in a future version _after_ the core registry + adapter system is fully working.
Not “bad ideas,” just “later ideas.”

🔹 No off-chain oracle network yet  
🔹 No real Chainlink OCR / API3 integrations yet  
🔹 No cross-chain status feeds yet  
🔹 No token economics or slashing mechanisms yet  
🔹 No redesign of the entire architecture around oracle logic yet

---

## 5. Where this goes in roadmap

| Version | Feature                                                  |
| ------- | -------------------------------------------------------- |
| v0      | MVP: registry + factory + adapters (manual control)      |
| v1      | Add multisig + timelock to registry                      |
| v2      | Add adapter validation (hash whitelist, versioning)      |
| v3      | Add oracle-based routing (this note)                     |
| v4      | Add distributed reporters (off-chain + on-chain signing) |
| v5      | Add staking/slashing if I want economic security         |

So this note = **v3**, AFTER baseline system is solid.

---

## 6. Files this feature would eventually add

```
/src/oracle/BridgeStatusOracle.sol
/src/interfaces/IBridgeStatusOracle.sol
/src/registry/BridgeRegistryV2.sol   (optional upgrade when oracle added)
```

---

## 7. Study keywords for later

- "Chainlink OCR" (off-chain reporting)
- "optimistic oracle" (UMA model)
- "oracle registry pattern"
- "liveness vs correctness guarantees"
- "risk-based routing"
- "bridge downtime analytics"
- "slashing oracles"
- "upgradable data feeds via proxy or pull model"

---

## 8. What to do FIRST if I forget everything later

✅ Build the mock oracle
✅ Make registry _read_ from oracle instead of owner variable
✅ Update tests to simulate bridge failure
✅ Don’t worry about fancy off-chain reporting yet

That’s the entry-level version.

If I can do THAT, I have learned the oracle pattern.

Everything after that is scaling, not learning.

---

## 9. One-sentence reminder to future me

> “The oracle does NOT send messages — it only decides _which adapter is safe to use_.”

If I forget this, reread this note before adding 200 lines of code I don’t need.

---

## 10. Why this is worth learning eventually

Because **bridges fail in the real world**, and every protocol that hard-codes one bridge eventually becomes unresponsive or bankrupt.

A modular bridge router is useful.
A **self-healing router** is valuable.

---
