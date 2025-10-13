# 🌱 minimal-onchain-ecosystem

A living collection of small, composable smart contracts that form a **minimal on-chain ecosystem** — lightweight, modular, and chaos-architected by _qTee_. 🐱‍👤✨

Instead of treating each pattern as an isolated study, this repo blends them into a single ecosystem where factories, registries, adapters, and oracles work together like micro-organisms.

---

## 💡 What’s Inside

Each module includes:

- 🧠 concise notes in its own `README.md`
- 🧪 working Solidity implementation
- ✅ Foundry tests
- 🚀 optional deploy scripts

> Inspired by [dragonfly-xyz/useful-solidity-patterns](https://github.com/dragonfly-xyz/useful-solidity-patterns)

---

## 🧱 Ecosystem Structure

```
minimal-ecosystem/
 ├─ contracts/
 │   ├─ factory/
 │   ├─ registry/
 │   ├─ adapter/
 │   ├─ oracle/
 │   ├─ proxy/
 │   └─ access/
 │
 ├─ script/   → deployment & setup
 ├─ test/     → unit + integration tests
 └─ foundry.toml
```

Each folder represents a small building block that can live on its own or combine with others to form complete on-chain systems.

---

## 🧩 Core Components

- 🏭 `factory/` — spawns new modules
- 🗂️ `registry/` — tracks & manages factory and module
- 🔐 `access/` — permission & ownership logic
- 🧾 `proxy/` — upgrade & indirection patterns
- 💸 `pull-payment/` — safe payment flows
- 🧩 `adapter/` — bridges & extensions
- 🔮 `oracle/` — off-chain data hooks

_(more organisms to come...)_

---

## 🎯 Long-Term Goal

Use this ecosystem as a base for deeper work in:

- ✅ formal verification (prove invariants)
- 🔍 fuzz/property testing
- 🔒 zero-knowledge & on-chain logic modeling

---

## ⚙️ Tooling

Built with [Foundry](https://book.getfoundry.sh/) for testing, scripting, and rapid iteration.

```bash
# setup
forge install
anvil

# run tests
forge test

# deploy (example)
source .env
forge script script/DeployEcosystem.s.sol --rpc-url $RPC_URL
```

---

soft rule of thumb: keep every contract minimal, explicit, and composable —
**tiny parts, big ecosystems.** 🌱✨
