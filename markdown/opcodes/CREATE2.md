### CREATE2

When deploying a smart contract in a non-deterministic way, the address is derived from:

1. The deployers address
2. The wallet's transaction count (nounce)
   and
3. The to-be-deployed contract's bytecode.

`CREATE2` is an EVM opcode that lets you precompute a contract's address. &rarr; the address is _deterministic_

```solidity
address = keccak256(
  0xff ++ factoryAddress ++ salt ++ keccak256(creationCode)
)
```

---

#### ⚠️ Security risks

CREATE2 introduces predictability, which is both a feature and a risk. Below are some of the security risks introduced by CREATE2.

##### Pre-funding

> ❗ Attack: An attacker sends ETH or tokens to your `CREATE2` address before it’s deployed.

---

##### Front-Running Your CREATE2 Logic

> ❗ Attack: If you're about to deploy something valuable (e.g., minting contract), and the address is predictable...

Attackers can **monitor mempool** & try to:

- Pre-deploy to block you
- **Sandwich** your deployment
- Race to interact with your freshly deployed contract

---

##### Smear Campaign

> ❗ Attack: Attacker predeploy a contract your predicted `CREATE2` address, interacting with other protocols, and then **self-destruct** to "free up" the address.

In that case, this address likely have **lingering associations** to the contract deployed by the attacker, affecting future contract deployed to it.

---

##### 💡 Prevention

- **Before deploying to any address in a production setting, check the _entire on chain history_ of the adress.**
- **Avoid reusing `CREATE2` salts across testnets / mainnet.**
- **Deploy and initialize Atomically.**
  **Remove any window** between deployment and initialization / setup! Make all steps happen in **one transaction**. Anything fails &rarr; Revert whole tx ❕
