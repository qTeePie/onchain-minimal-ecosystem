# Factory Pattern

- [📄 Example Code](./Factory.sol)
- [💚 Tests](../../test/Factory.t.sol)

A classic example of this pattern in the blockchain realm is `UniswapV2Factory`, who dynamically spawns liquidity pool by deploying new `UniswapV2Pair` contracts.

> ❗ **Tip:** reading through the [UniswapV2Core](https://github.com/Uniswap/v2-core) contracts is a great introduction to solidity blockchain development. It’s minimal, readable, and shows how clean architecture can scale without unnecessary complexity.

The factory example implemented here is inspired by **Uniswap** 🦄, a factory contract deploying a minimal pair comtract, using CREATE2 to deploy at a predictable address. 🚀

## ✨ Benefits

- Efficient mass deployment of similar contracts.
- Predictability in deployment logic.

## ⚠️ Tradeoffs

- CREATE2 introduces predictability, which is both a feature and a risk (more in this below.)

---

### CREATE2 Considerations

While `CREATE2` is incredibly useful for predictable address deployment, it comes with its own caveats and risks.

---

### 💰 Pre-funding

> ❗ Attack: An attacker sends ETH or tokens to your `CREATE2` address before it’s deployed.

---

#### 🥪 Front-Running Your CREATE2 Logic

> ❗ Attack: If you're about to deploy something valuable (e.g., minting contract), and the address is predictable...

Attackers can **monitor mempool** & try to:

- Pre-deploy to block you
- **Sandwich** your deployment
- Race to interact with your freshly deployed contract

---

#### ☠ Smear Campaign

> ❗ Attack: Attacker predeploy a contract your predicted `CREATE2` address, interacting with other protocols, and then **self-destruct** to "free up" the address.

In that case, this address likely have **lingering associations** to the contract deployed by the attacker, affecting future contract deployed to it.

#### 💡 Prevention

✅ **Before deploying to any address in a production setting, check the _entire on chain history_ of the adress.**
✅ **Avoid reusing `CREATE2` salts across testnets / mainnet.**
✅ **Deploy and initialize Atomically.**
**Remove any window** between deployment and initialization / setup! Make all steps happen in **one transaction**. Anything fails &rarr; Revert whole tx ❕
