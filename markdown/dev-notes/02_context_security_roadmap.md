## 9. 🔐 Security Notes (for future versions, NOT for MVP)

These are **NOT** required in MVP, but future-you must remember them so you don’t ship something dangerous and call it “trustless” when it’s not.

```
⚠️ KEY RULE: MVP is owner-controlled. That is OK as long as you SAY SO.
DO NOT pretend MVP is decentralized or governance-safe. Be honest.
```

Future production version must add:

| Security Layer                        | Why it matters                                             |
| ------------------------------------- | ---------------------------------------------------------- |
| Timelock on adapter changes           | Prevents instant malicious swap (gives users time to exit) |
| Whitelisted adapter codehashes        | Stops a DAO from setting a malicious adapter impl          |
| Multisig instead of EO owner          | Removes single key risk                                    |
| Optional guardian pause               | Protects during bridge exploit windows                     |
| Optional “user override” param        | Lets power users avoid registry-level routing              |
| Slashing / staking for adapters       | Ensures economic penalty for malicious routing             |
| Rate-limited adoption of new adapters | Limits blast radius on untested adapters                   |
| Event indexer for monitoring          | Alert if adapter changes unexpectedly                      |

🚨 Future trap: If app contract executes arbitrary payloads from adapter messages, **NEVER trust the adapter blindly** — require proofs or message auth.

---

## 10. Real Incidents Proving This Architecture Is Needed

✅ **Multichain (2023–2024)** — keys compromised, bridge shut down, devs disappeared
→ 100+ protocols **trapped forever** because they hard-coded Multichain
→ Example: Fantom bridged assets stuck, TVL nuked

✅ **Harmony Bridge Hack ($100M, 2022)**
→ No exit path, had to mint “IOU tokens” as workaround
→ Hard-coded bridge dependency = unrecoverable

✅ **Celer cBridge outage**
→ Withdrawal queue paused → protocols relying on it froze

✅ **Axelar halt**
→ 6-hour downtime → apps could not route messages elsewhere

✅ **LayerZero paused endpoints mid-cycle**
→ Some dApps had to halt apps in production

🧠 Pattern: Bridges fail, pause, get hacked, or disappear.
Apps without routing abstraction → screwed.
Apps WITH abstraction → they can migrate bridge infra without redeploying app logic.

That is the whole business case.

---

## 11. EIPs + Related Standards To Read Later

(Not required for MVP, but future-you will need these)

| Topic                       | Reference                                       |
| --------------------------- | ----------------------------------------------- |
| Minimal proxy pattern       | **EIP-1167** (factory clones) ✅ (relevant now) |
| Cross-chain messaging       | LayerZero docs, Axelar GMP, Hyperlane Mailbox   |
| Upgrade safety              | **EIP-1822** (UUPS), **EIP-1967** (proxy slots) |
| Meta-transaction pattern    | ERC-2771 (optional for overrides)               |
| Modular token patterns      | ERC-2535 Diamond (only inspiration, not needed) |
| Bridge security papers      | Chainlink CCIP risk report, L2Beat bridge risks |
| Generalized router patterns | Uniswap V3 swap router, ERC-4337 entry point    |

🧠 Note: There is **NO** EIP for “Modular Bridge Routing” yet → this could _become one_ someday.

---

## 12. Failure Traps to Avoid (Reminder to Self)

- **Do NOT** try to implement real bridging in v1 → waste of time, not needed
- **Do NOT** add DAO or tokens now → this bloats scope and kills progress
- **Do NOT** add real LZ/Axelar endpoints → mocks are fine until v2
- **Do NOT** try to support 5 adapters in MVP → 2 is enough to demo swap
- **Do NOT** make registry upgradeable → defeats purpose of immutability model
- **Do NOT** use abstract contracts without tests → this MUST be test-driven
- **Do NOT** build UI before core works → UI can come 1 month later
- **Do NOT** forget to emit events — this is your “visual proof” in logs

---

## 13. Roadmap After MVP

### ✅ MVP (now)

- Owner-controlled registry
- 2 mock adapters
- Factory deploys clones
- Example app + tests

### 🔁 v2 (when comfortable)

- Whitelist adapter implementation hashes
- Add timelock for registry changes
- Add `pause()` fail-safe
- Add script to deploy to Goerli / Sepolia

### 🏛️ v3 (job-ready version)

- Multisig controls registry
- Add off-chain watcher bot + Telegram alert
- Add real LayerZero adapter & Axelar adapter
- Write blog post: “Why immutable apps need swappable routing”

### 🔒 v4 (security-engineer grade)

- DAO governance with timelock + veto council
- User override optional param
- Adapter staking + slash if malicious
- Formal verification of `send()` + registry mapping invariants

---
