# 🔐 AccessControl pattern

"Who is allowed to do what" - important in any type of development, also for smart contarcts.

> ❗ **Tip:** reading through the [Open Zeppelin](https://github.com/Uniswap/v2-core) Ownable.sol implementation is a great way to get familiar with _ownership_, the most common form of access control.

📚 2. What to read / where to look

OpenZeppelin Contracts → contracts/access/Ownable.sol
study that file; it’s only ~40 lines of logic.
You’ll learn:

how to store the owner address

how to use the onlyOwner modifier

how to transfer or renounce ownership

Solidity docs → Contracts → Inheritance & Visibility
to understand how modifiers guard functions.

“Access Control” section in the OZ docs → compares Ownable vs AccessControl.
(The latter uses roles; you probably don’t need that yet.)
