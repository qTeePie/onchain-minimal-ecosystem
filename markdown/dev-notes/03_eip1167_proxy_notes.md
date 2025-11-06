## EIP-1167 Notes (How the Proxy Pattern Fits Here)

**Key reminder:**
You _can_ use EIP-1167 in this project — you just don’t use **one shared implementation** for all bridges.
Each bridge adapter has **its own implementation**, and the factory deploys **clones of that implementation**.

So the pattern is:

```
[LayerZeroAdapterImplementation]
    ├─ clone 1 (for chain X)
    ├─ clone 2 (for chain Y)
    └─ clone 3 (for chain Z)

[AxelarAdapterImplementation]
    ├─ clone 1 (for chain X)
    ├─ clone 2 (for chain Y)
    └─ clone 3 (for chain Z)
```

✅ Clones = cheap deployments
✅ Each adapter still has unique logic
✅ All adapters conform to the same interface:

```solidity
function send(uint256 dstChainId, bytes calldata payload) external payable;
```

**DO NOT confuse this with:**

❌ “One implementation for all bridges” → impossible
✅ “One implementation per bridge type, cloned many times” → correct

---

### Why 1167 still makes sense here

- Deploying the full bytecode of each adapter repeatedly = expensive
- Cloning lets you deploy cheap lightweight proxies instead
- Factory pattern lets you track, emit, and index adapter deployments
- You still get “factory → clone → registry” architecture that interviewers like

---

### Minimal Factory Skeleton

```solidity
import {Clones} from "openzeppelin-contracts/proxy/Clones.sol";

contract AdapterFactory {
    event AdapterDeployed(address implementation, address proxy);

    function deployAdapter(address implementation, bytes calldata initData)
        external
        returns (address proxy)
    {
        proxy = Clones.clone(implementation); // EIP-1167 proxy
        if (initData.length > 0) {
            (bool ok,) = proxy.call(initData);
            require(ok, "init failed");
        }
        emit AdapterDeployed(implementation, proxy);
    }
}
```

✅ `implementation` = LayerZeroAdapterImpl, AxelarAdapterImpl, etc.
✅ `initData` = optional `initialize(...)` call
✅ Factory doesn’t care what the adapter _does_, only that it matches the interface

---

### Folder Layout Reminder

```
/src
  AdapterFactory.sol
  BridgeRegistry.sol
  IBridgeAdapter.sol
  adapters/
    LayerZeroAdapterImpl.sol
    AxelarAdapterImpl.sol
    HyperlaneAdapterImpl.sol
```

---

### The ONE thing to remember

**You are not cloning “bridge logic,” you are cloning “bridge adapter instances.”**

The registry stores:

```
chainId → adapterProxyAddress
```

NOT:

```
chainId → implementationAddress
```

That’s why the factory matters — it creates _deployable_ proxies, not shared logic.

---

### Quick sanity check (Future-You):

If you ever start thinking “wait… these adapters are different, so I can’t use 1167,”
STOP and remember:

> “I’m not trying to clone **between** bridges —
> I’m cloning **within** each bridge type.”

That’s the whole pattern.
