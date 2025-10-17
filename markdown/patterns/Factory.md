# 🏭 Factory Pattern

A classic example of this pattern in the blockchain realm is `UniswapV2Factory`, who dynamically spawns liquidity pool by deploying new `UniswapV2Pair` contracts.

> ❗ **Tip:** reading through the [UniswapV2Core](https://github.com/Uniswap/v2-core) contracts is a great introduction to solidity blockchain development. It’s minimal, readable, and shows how clean architecture can scale without unnecessary complexity.

The factory example implemented here is inspired by **Uniswap** 🦄, a factory contract deploying a minimal pair comtract, using CREATE2 to deploy at a predictable address. 🚀

---

## 🧐 Why ?

### Programmatic deployments

In blockchain ecosystems such as Uniswap, where new contracts are deployed frequently with identical logic and only their parameters vary, automating deployments makes the entire system significantly more scalable and efficient.

---

### Centralized tracking

If you work with a factory+registry coupled system, the factory works as a sort of bookkeeper for its child contracts (the contracts it deploys), storing their addresses, relevant timestamps, and event emition.

In a decoupled design, this bookkeeping responsibility is delegated to an external registry, while the factory focuses solely on deployment logic.

---

### Consistency

In the immutable world of blockchain, maintaining consistency is usually very important for a system to maintain its reliability and fairness among the system's users.

Here’s the factory contract. It’s immutable. It’s on-chain.

> Every liquidity pair will be created through this factory, and only this one.
> That single rule gives users, traders, and integrators confidence that:

every pair (like ETH/DAI, ETH/USDC)
🧩 follows the same code
🧩 obeys the same fee logic
🧩 calculates prices the same way

If the method of deploying new pair contracts in Uniswap wasn’t a “set in blockchain-stone”, instead of having one immutable factory, they used some “off-chain method” or “manual deploy script”, there wouldn't be a "set in stone" way —

then suddenly:

- One pair could have a different swap formula
- Another could charge different fees

💀 That would break the fairness, destroy trust, and make the system exploitable.

---

### Improving Security

(Read this) 👉 [Factories Improve Smart Contract Security — ConsenSys Diligence](https://diligence.consensys.io/blog/2019/09/factories-improve-smart-contract-security/)

---

## 🏗️ Factory Pattern Extensions

### Gas Improvement

The gas cost for the CREATE opcode is presently 32,000 Gwei. Each time an instance of the Foundation contract is deployed, a gas fee of 32,000 Gwei is charged.

The major drawback of the normal factory pattern is high gas costs. And that’s where the cloned factory pattern comes in handy.

Gas costs FP: https://ethereum.stackexchange.com/questions/84764/high-gas-cost-for-factory-contract

**The clone factory pattern: The right pattern for deploying multiple instances of our Solidity smart contract**

CLONE FP: https://blog.logrocket.com/cloning-solidity-smart-contracts-factory-pattern/
DELEGATE CALL: https://medium.com/coinmonks/delegatecall-calling-another-contract-function-in-solidity-b579f804178c

#### Proxies

---
