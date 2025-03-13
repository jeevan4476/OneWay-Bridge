# Ethereum to Base Token Bridge

This repository contains a one-way token bridge that allows users to transfer tokens from the Ethereum blockchain to the Base blockchain. The smart contract locks tokens on Ethereum and mints equivalent tokens on Base.

## Overview

- **BridgeETH.sol**: Manages token locking on Ethereum.
- **BridgeBase.sol**: Handles minting tokens on Base.
- **WJcoin.sol**: ERC-20 token contract used in the bridge.
- **Tests**: Foundry-based test suite for validating contract functionality.

## Features

✅ Lock tokens on Ethereum  
✅ Mint equivalent tokens on Base  
✅ Secure ownership-based minting  
✅ Basic permission controls  

## Installation

Ensure you have [Foundry](https://book.getfoundry.sh/) installed:

```sh
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Clone the repository and install dependencies:

```sh
git clone <repo-url>
cd <repo-name>
forge install
```

## Running Tests

To execute tests, run:

```sh
forge test
```

## Usage

### Locking Tokens (Ethereum)

Users must approve the bridge contract before locking tokens:

```solidity
IERC20(tokenAddress).approve(bridgeAddress, amount);
BridgeETH(bridgeAddress).lock(tokenAddress, amount);
```

### Unlocking Tokens (Base)

Once the deposit is recorded on Base by the bridge owner:

```solidity
BridgeBase(bridgeAddress).withdraw(tokenAddress, amount);
```

## Limitations

🚧 **One-way bridge:** Transfers only from Ethereum to Other blockchain.  
🚧 **No automated relayer:** The owner must manually confirm deposits on Base.  

## Roadmap

- [ ] Implement a two-way bridge (Other Blockchain → Ethereum)  
- [ ] Integrate cross-chain relayer  

## License

This project is licensed under the MIT License.

