# Base NFT Collection

Private NFT collection on Base with owner-controlled mint.

## Features

- ERC-721 standard
- Configurable max mints per wallet
- Fixed mint price with ETH payment
- Owner can toggle mint and withdraw funds

## Usage

1. Deploy with name, symbol, maxPerWallet, and mintPrice
2. Owner calls `setMintConfig(..., true)` to enable mint
3. Users call `mint(uri)` with required ETH
4. Owner can withdraw collected ETH anytime

## Notes

Private repo for internal experiments. Audit before any public or paid mint.
