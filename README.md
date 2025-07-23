# 🧱 solidity-design-patterns

A curated collection of real-world Solidity design patterns — tested, explained, and chaos-architected by _qTee_. 🐱‍👤✨

## 💡 What’s Inside

Each pattern has:

- 🧠 Notes and explanations (in its own `README.md`)
- 🧪 A working Solidity implementation
- ✅ Foundry tests
- 🚀 A deploy script (if needed)

> Inspired by [dragonfly-xyz/useful-solidity-patterns](https://github.com/dragonfly-xyz/useful-solidity-patterns) but written from scratch, reorganized for clarity, and expanded with personal insights.

---

## 📦 Patterns

- 🏭 `factory/`
- 🗂️ `registry/`
- 🔐 `access-control/`
- 🧾 `proxy/`
- 💸 `pull-payment/`
- 🧩 `adapter/`
- 🔮 `oracle/`
- 🌀 `state-machine/` _(coming soon)_

---

## 🧰 Tooling

This repo uses [Foundry](https://book.getfoundry.sh/) for testing, scripting, and fast iteration.

```bash
# setup
forge install
anvil

# run tests
forge test

# run deploy script (optional)
source .env
forge script script/DeployFactory.s.sol --rpc-url $RPC_URL
```
