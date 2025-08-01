# Factory Pattern

- [📄 Example Code](./Factory.sol)
- [💚 Tests](../../test/Factory.t.sol)

A classic example of this pattern in the blockchain realm is `UniswapV2Factory`, who dynamically spawns liquidity pool by deploying new `UniswapV2Pair` contracts.

> ❗ **Tip:** reading through the [UniswapV2Core](https://github.com/Uniswap/v2-core) contracts is a great introduction to solidity blockchain development. It’s minimal, readable, and shows how clean architecture can scale without unnecessary complexity.

The factory example implemented here is inspired by **Uniswap** 🦄, a factory contract deploying a minimal pair comtract, using CREATE2 to deploy at a predictable address. 🚀

---

### CREATE2 Considerations

While `CREATE2` is incredibly useful for predictable address deployment, it comes with its own caveats and risks.

#### ☠ Smear Campaign

❗ Attackers predeploy a contract to the intended address, interacting with other protocols, and then **self-destruct** to "free up" the address.

In that case, this address likely have **lingering associations** to the contract deployed by the attacker, affecting future contract deployed to it.

> Even though deploying with CREATE2 resets the contract's internal storage, the address itself might already be recognized or referenced by other protocols. This means your contract can unintentionally inherit residual effects, such as token approvals, role assignments, or whitelisted permissions — potentially leading to unexpected behavior.

#### 💡 Prevention

✅ **Before deploying to any address in a production setting, check the _entire on chain history_ of the adress.**
✅ **Avoid reusing `CREATE2` salts across testnets / mainnet.**
✅ **Deploy and initialize Atomically.**
**Remove any window** between deployment and initialization / setup! Make all steps happen in **one transaction**. Anything fails &rarr; Revert whole tx ❕
