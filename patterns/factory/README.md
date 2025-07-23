# Factory Pattern

- [📄 Example Code](./Factory.sol)
- [💚 Tests](../../test/Factory.t.sol)

A classic example of this pattern in the blockchain realm is `UniswapV2Factory`, who dynamically spawns liquidity pool by deploying new `UniswapV2Pair` contracts.

> ❗ **Tip:** reading through the `UniswapV2Core` contracts is a great introduction to solidity blockchain development. It’s minimal, readable, and shows how clean architecture can scale without unnecessary complexity.
